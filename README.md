# mpv_config2
mpv_1440p显示器_高功耗配置

自己用的 mpv 配置文件哒，内容都是抄的啦。

###  MPV下载
https://sourceforge.net/projects/mpv-player-windows/files/64bit/

新版棒棒的
https://sourceforge.net/projects/mpv-player-windows/files/64bit-v3/

### 部分内容写在这里
https://github.com/NeilTohno/mpv_config

### 使用方法
打包下载，自己搜索怎么操作，

把 附件_cczzhh_分享一下自己的mpv配置.mpv.zip 以外的所有文件复制到 mpv 目录下

### 其他说明
先说明这个真是高端台式机才能流畅用的配置，比如 intel i7(amd R7) + RTX 4070(RX 7800xt)，2k 专用，低于这个也不是不行，假如 GPU 使用率总是 99% 那种状况就不合适了；

1080p 屏， 4K 屏 用户需要自己改配置，自己看 "附件_cczzhh_分享一下自己的mpv配置.mpv.zip"，

要改的内容并不多，我还在用旧版的 auto-profiles.lua，原因是对新手很友好啊，

还有，部分内容改动的不是很彻底，比如 input.conf，如果有人想提供自己改好的版本，可以发在 issues 那里，谢过。

### 其他说明2
仅适合高端配置的 PC 用户，2K 显示器

更改很多，现在要求使用者自己查看编辑部分文件，
要查看的文件： mpv参考文档.txt auto_load_fonts.conf mpv.conf input.conf mpv_ani.conf，
需要按自己需求编辑的文件：auto_load_fonts.conf mpv.conf input.conf mpv_ani.conf

如果出现人音小背景音大的问题，
把 ffmpeg 文件夹里 2 .bat 个文件拷贝到要播放文件的文件夹，这样可以创建两个 WavPack 文件，
播放中按快捷键 a 切换来切换到某个音轨

【需要从 https://www.gyan.dev/ffmpeg/builds/ 下载 ffmpeg-release-full-shared.7z 或者 ffmpeg-release-full.7z，
把 bin 文件夹里的文件全部 解压到要播放文件的文件夹。
当然你可以把 bin 文件夹里的文件解压到 某个特定文件夹，例如 X:\ffmpeg ，并添加这个路径到系统变量 path 里面。】

有问题反馈。

