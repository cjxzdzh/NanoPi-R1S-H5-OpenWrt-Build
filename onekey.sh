#!/bin/bash
sudo apt-get update
#安装编译所需依赖
wget -O - https://raw.githubusercontent.com/friendlyarm/build-env-on-ubuntu-bionic/master/install.sh | bash
#安装friendlyarm的repo
git clone https://github.com/friendlyarm/repo
sudo cp repo/repo /usr/bin/
mkdir friendlywrt-h5
cd friendlywrt-h5
#初始化repo
repo init -u https://github.com/friendlyarm/friendlywrt_manifests -b master -m h5.xml --repo-url=https://github.com/friendlyarm/repo  --no-clone-bundle
#下载skytotwo的h5.xml
cd .repo/manifests
rm -f ./h5.xml
wget https://raw.githubusercontent.com/skytotwo/NanoPi-R1S-Build-By-Actions/master/source_xml/h5_19.07.xml
cp h5_19.07.xml h5.xml
rm -rf ./h5_19.07.xml
#使用skytotwo的h5.xml同步文件，skytotwo的h5.xml指定了版本为18061,这个版本编译出来的固件问题相比最新版的少很多，新版的WIFI有大问题。
repo sync -c  --no-clone-bundle
cd ..
cd ..
#同步coolsnowwolf的lede
git clone https://github.com/coolsnowwolf/lede
cd friendlywrt
cp -r ../lede/package/lean package/
#删除openwrt的更新下载源，改为lede的源
sed -i 's/https:\/\/git.openwrt.org\/project\/luci.git^039ef1f4deba725d3591b159bbc9569885d68131/https:\/\/github.com\/coolsnowwolf\/luci/' feeds.conf.default
sed -i 's/https:\/\/git.openwrt.org\/feed\/packages.git^00803ffc91e80b16e9c1603ff32106d42e255923/https:\/\/github.com\/coolsnowwolf\/packages/' feeds.conf.default          
cd package
#这里装了个自定义插件koolproxy
git clone https://github.com/Baozisoftware/luci-app-koolproxy
cd ..
cd include
#这里把目标mk里的dnsmasq替换成了dnsmasq-full default-settings luci。
sed -i 's/dnsmasq /dnsmasq-full default-settings luci /' target.mk
cd ..
./scripts/feeds update -a
./scripts/feeds install -a
rm -f ./.config*
#使用skytotwo的r1s-h5-config作为默认的编译config，这里可以使用自己的config代替
wget https://raw.githubusercontent.com/skytotwo/NanoPi-R1S-Build-By-Actions/master/r1s-h5-config
cp r1s-h5-config .config
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;
cd ..
cd scripts
#替换build.sh和mk-friendlywrt.sh，主要避免一些奇怪的问题，略微修改了一点。
rm -f build.sh
wget https://raw.githubusercontent.com/cjxzdzh/NanoPi-R1S-H5-OpenWrt-Build/master/build.sh
rm -f mk-friendlywrt.sh
wget https://raw.githubusercontent.com/cjxzdzh/NanoPi-R1S-H5-OpenWrt-Build/master/mk-friendlywrt.sh
sudo chmod 777 build.sh
sudo chmod 777 mk-friendlywrt.sh
cd ..
#最终编译
./build.sh nanopi_r1s.mk
cd ..
#压缩大小
find friendlywrt-h5/out/ -name "FriendlyWrt_*img*" | xargs -i zip -r {}.zip {}

