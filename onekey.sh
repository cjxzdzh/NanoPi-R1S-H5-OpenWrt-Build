rm -f build.sh
wget -O build.sh https://raw.githubusercontent.com/cjxzdzh/-NanoPi-R1S-H5-Build/master/build.sh
rm -f mk-friendlywrt.sh
wget -O mk-friendlywrt.sh https://raw.githubusercontent.com/cjxzdzh/-NanoPi-R1S-H5-Build/master/mk-friendlywrt.sh
cd ..
sudo ./build.sh nanopi_r1s.mk
cd ..
find friendlywrt-h5/out/ -name "FriendlyWrt_*img*" | xargs -i zip -r {}.zip {}
