rm -f mk-friendlywrt.sh
wget https://raw.githubusercontent.com/cjxzdzh/-NanoPi-R1S-H5-Build/master/mk-friendlywrt.sh
cd ..
sudo ./build.sh nanopi_r1s.mk
cd ..
find friendlywrt-h5/out/ -name "FriendlyWrt_*img*" | xargs -i zip -r {}.zip {}
