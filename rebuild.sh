cd ./friendlywrt-h5
./build.sh cleanall
./build.sh nanopi_r1s.mk
cd ..
#压缩大小
find friendlywrt-h5/out/ -name "FriendlyWrt_*img*" | xargs -i zip -r {}.zip {}
