#!/bin/bash
sudo apt-get update
wget -O - https://raw.githubusercontent.com/friendlyarm/build-env-on-ubuntu-bionic/master/install.sh | bash
git clone https://github.com/friendlyarm/repo
sudo cp repo/repo /usr/bin/
mkdir friendlywrt-h5
cd friendlywrt-h5
repo init -u https://github.com/friendlyarm/friendlywrt_manifests -b master -m h5.xml --repo-url=https://github.com/friendlyarm/repo  --no-clone-bundle
#使用skytotwo的h5.xml
cd .repo/manifests
rm -f ./h5.xml
wget https://raw.githubusercontent.com/skytotwo/NanoPi-R1S-Build-By-Actions/master/source_xml/h5_19.07.xml
cp h5_19.07.xml h5.xml
rm -rf ./h5_19.07.xml
repo sync -c  --no-clone-bundle
cd ..
cd ..
git clone https://github.com/coolsnowwolf/lede
cd friendlywrt
cp -r ../lede/package/lean package/
rm -f ./feeds.conf.default
wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/feeds.conf.default
cd package
#这里装了个自定义插件koolproxy
git clone https://github.com/Baozisoftware/luci-app-koolproxy
cd ..
cd include
#这里把目标mk里的dnsmasq替换成了dnsmasq-full default-settings luci。
sed -i 's/dnsmasq /dnsmasq-full default-settings luci /' target.mk
cd ..
rm -f ./.config*
#使用skytotwo的r1s-h5-config
wget https://raw.githubusercontent.com/skytotwo/NanoPi-R1S-Build-By-Actions/master/r1s-h5-config
cp r1s-h5-config .config
cd ..
cd scripts
rm -f build.sh
wget https://raw.githubusercontent.com/cjxzdzh/-NanoPi-R1S-H5-Build/master/build.sh
rm -f mk-friendlywrt.sh
wget https://raw.githubusercontent.com/cjxzdzh/-NanoPi-R1S-H5-Build/master/mk-friendlywrt.sh
sudo chmod 777 build.sh
sudo chmod 777 mk-friendlywrt.sh
cd ..
./build.sh nanopi_r1s.mk
cd ..
find friendlywrt-h5/out/ -name "FriendlyWrt_*img*" | xargs -i zip -r {}.zip {}
