使用方法：

1.编译的电脑需要全局科学上网，网络需要够稳定，否则会导致下载的数据有丢失

2.编译需要下载大约10个G的数据

3.推荐使用 Ubuntu 18.04系统编译，使用VPS编译更佳

4.系统需要有25G以上的空间预留给编译


wget -O - https://raw.githubusercontent.com/cjxzdzh/NanoPi-R1S-H5-OpenWrt-Build/master/onekey.sh | bash

编译成功后，Img文件在./friendlywrt-h5/out下,拷贝到windows下，使用Win32DiskImager之类的软件将文件写入TF卡内，插回设备，设备上电即可，默认地址192.168.2.1,账号root，密码password。

首次编译成功后，可以执行命令

cd ./friendlywrt-h5/friendlywrt/

make menuconfig

修改编译功能，如果增加了功能，需要将target images下的root filesystem partition size改成更大的数值（如512）。

修改后save，然后执行

cd ../..

最后重编译即可，运行

wget -O - https://raw.githubusercontent.com/cjxzdzh/NanoPi-R1S-H5-OpenWrt-Build/master/rebuild.sh | bash



代码来源-skytotwo的在线编译版：https://github.com/skytotwo/NanoPi-R1S-Build-By-Actions

代码来源-lede：https://github.com/coolsnowwolf/lede

代码来源-NanoPi官方：https://github.com/friendlyarm

代码来源-Openwrt官方：https://github.com/openwrt/openwrt

