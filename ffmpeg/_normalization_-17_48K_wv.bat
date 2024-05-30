@echo off
::original post, www.bilibili.com/read/cv17301168/

setlocal EnableDelayedExpansion

@rem Integrated Loudness, True Peak, Loudness Range
set loudness=-17
set truepeak=-1
set loudrange=11
@rem Directory for temporary Wave64 file
set tmpdir=

@rem Detect bit-depth of input audio stream
ffprobe -v error -select_streams a:0 -show_entries stream=bits_per_sample,bits_per_raw_sample -of csv=p=0 %1 > %1.txt 2>&1

for /f "tokens=1,2 delims=," %%a in ('type %1.txt') do (
    set bits=%%a
    set bits_raw=%%b
)

if !bits! == N/A set bits=0
if !bits_raw! == N/A set bits_raw=0

if !bits! == !bits_raw! (set /a bit_depth=!bits!) else (
    set /a bit_depth=!bits! + !bits_raw!
)

echo.
if !bit_depth! == 0 (echo bit-depth of the original audio is N/A) else (
    echo bit-depth of the original audio is !bit_depth!
)
echo.

@rem Convert to at least 32-bit PCM for processing
if !bit_depth! leq 32 (set bit_pcm=32) else (set bit_pcm=!bit_depth!)
echo using !bit_pcm!-bit for nomalization process
echo.

@rem First pass: analyze audio stream and get normalization parameters
ffmpeg -hide_banner -i %1 -c:a:0 pcm_f32le -af "aresample=osr=192000:osf=fltp:cutoff=1.00:resampler=soxr:precision=33:cheby=1, loudnorm=I=!loudness!:TP=!truepeak!:LRA=!loudrange!:print_format=json" -f null - 2>%1.txt

for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"input_i" %1.txt') do (set II=%%a)
for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"input_tp" %1.txt') do (set ITP=%%a)
for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"input_lra" %1.txt') do (set ILRA=%%a)
for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"input_thresh" %1.txt') do (set IT=%%a)
for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"output_i" %1.txt') do (set OI=%%a)
for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"output_tp" %1.txt') do (set OTP=%%a)
for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"output_lra" %1.txt') do (set OLRA=%%a)
for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"output_thresh" %1.txt') do (set OT=%%a)
for /f delims^=^"^ tokens^=4 %%a in ('findstr /C:"target_offset" %1.txt') do (set TO=%%a)

echo Input Integrated:     !II!
echo Input True Peak:      !ITP!
echo Input LRA:            !ILRA!
echo Input Threshold:      !IT!
echo Output Integrated:    !OI!
echo Output True Peak:     !OTP!
echo Output LRA:           !OLRA!
echo Output Threshold:     !OT!
echo Target Offset:        !TO!
echo.

@rem Second pass: produce normalized Wave64 file
@rem Sample rate will be 192kHz if in dynamic normalization mode
echo loudnorm=I=!loudness!:TP=!truepeak!:LRA=!loudrange!:measured_I=!II!:measured_tp=!ITP!:measured_LRA=!ILRA!:measured_thresh=!IT!:offset=!TO!
echo.
ffmpeg -hide_banner -y -i %1 -c:a:0  pcm_f32le -af "aresample=osr=192000:osf=fltp:cutoff=1.00:resampler=soxr:precision=33:cheby=1, loudnorm=I=!loudness!:TP=!truepeak!:LRA=!loudrange!:measured_I=!II!:measured_tp=!ITP!:measured_LRA=!ILRA!:measured_thresh=!IT!:offset=!TO!:print_format=summary" -acodec wavpack "!tmpdir!%~n1_!loudness!LUFS.wv"

::ffmpeg -h encode=wavpack 
timeout /t 1 /nobreak

ffmpeg -hide_banner -y -i "!tmpdir!%~n1_!loudness!LUFS.wv" -c:a wavpack -af "aresample=osr=48000:osf=fltp:resampler=soxr:precision=33:cheby=1" "!tmpdir!%~n1_!loudness!LUFS_2.wv"
echo.

@rem Encode Wave64 to AAC using QAAC
@rem Downsample to 48kHz automatically by built-in SoX
::qaac64 -V 127 -i --adts --no-delay "!tmpdir!%~n1_!loudness!LUFS".w64 -o "%~n1_!loudness!LUFS".aac
echo.

::del %1.txt
::del "!tmpdir!%~n1_!loudness!LUFS".w64

pause
