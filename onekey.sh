#!/bin/bash
sudo apt-get update
wget -O - https://raw.githubusercontent.com/friendlyarm/build-env-on-ubuntu-bionic/master/install.sh | bash
git clone https://github.com/friendlyarm/repo
sudo cp repo/repo /usr/bin/
mkdir friendlywrt-h5
cd friendlywrt-h5
repo init -u https://github.com/friendlyarm/friendlywrt_manifests -b master -m h5.xml --repo-url=https://github.com/friendlyarm/repo  --no-clone-bundle
#源码内有自定义h5.xml，暂时先不使用，看看情况
repo sync -c  --no-clone-bundle
git clone https://github.com/coolsnowwolf/lede
cd friendlywrt
cp -r ../lede/package/lean package/
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
#friendlyarm里的scripts其实包含了download、update和、install。这里先保留skytotwo写法
./scripts/feeds update -a
./scripts/feeds install -a
rm -f ./.config*
#使用skytotwo的r1s-h5-config
wget https://raw.githubusercontent.com/skytotwo/NanoPi-R1S-Build-By-Actions/master/r1s-h5-config
cp r1s-h5-config .config
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;
cd ..
cd scripts
rm -f mk-friendlywrt.sh
git clone https://github.com/cjxzdzh/-NanoPi-R1S-H5-Build
cp ./-NanoPi-R1S-H5-Build/mk-friendlywrt.sh mk-friendlywrt.sh
cd ..
cd ..
./build.sh nanopi_r1s.mk
cd ..
find friendlywrt-h5/out/ -name "FriendlyWrt_*img*" | xargs -i zip -r {}.zip {}
