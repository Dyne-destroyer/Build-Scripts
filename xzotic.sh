# Copyright © 2017, As007 "AkashPathange7" <akashpathange.aaa47@gmail.com>
#
# Custom build script
#
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/dtbTool
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export CROSS_COMPILE=~/android-kernel/aarch64-linux-gnu-6.2/bin/aarch64-linux-gnu-
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=As007
export KBUILD_BUILD_HOST=xzotified
MODULES_DIR=/home/as007/xzotic-1/COMMON
OUT_DIR=/home/as007/xzotic-1/XZOTIC

compile_kernel ()
{
echo -e "$green***********************************************************************************************************"
echo "+                ▄████▄   ▒█████   ███▄ ▄███▓ ██▓███   ██▓ ██▓     ██▓ ███▄    █   ▄████                  +"
echo "+               ▒██▀ ▀█  ▒██▒  ██▒▓██▒▀█▀ ██▒▓██░  ██▒▓██▒▓██▒    ▓██▒ ██ ▀█   █  ██▒ ▀█▒                 +"
echo "+               ▒▓█    ▄ ▒██░  ██▒▓██    ▓██░▓██░ ██▓▒▒██▒▒██░    ▒██▒▓██  ▀█ ██▒▒██░▄▄▄░                 +"
echo "+               ▒▓▓▄ ▄██▒▒██   ██░▒██    ▒██ ▒██▄█▓▒ ▒░██░▒██░    ░██░▓██▒  ▐▌██▒░▓█  ██▓                 +"
echo "+               ▒ ▓███▀ ░░ ████▓▒░▒██▒   ░██▒▒██▒ ░  ░░██░░██████▒░██░▒██░   ▓██░░▒▓███▀▒                 +"
echo "+               ░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ░  ░▒▓▒░ ░  ░░▓  ░ ▒░▓  ░░▓  ░ ▒░   ▒ ▒  ░▒   ▒                  +"
echo "+               ░  ▒     ░ ▒ ▒░ ░  ░      ░░▒ ░      ▒ ░░ ░ ▒  ░ ▒ ░░ ░░   ░ ▒░  ░   ░                    +"
echo "+               ░        ░ ░ ░ ▒  ░      ░   ░░        ▒ ░  ░ ░    ▒ ░   ░   ░ ░ ░ ░   ░                  +"
echo "+              ░ ░          ░ ░         ░             ░      ░  ░ ░           ░       ░                   +"
echo "+              ░                                                                                          +"
echo -e "***********************************************************************************************************$green"
make lineageos_lettuce_defconfig
make -j8
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
strip_modules
}

strip_modules ()
{
echo "Copying modules"
rm $MODULES_DIR/*
find . -name '*.ko' -exec cp {} $MODULES_DIR/ \;
cd $MODULES_DIR
echo "Stripping modules for size"
$STRIP --strip-unneeded *.ko
zip -9 modules *
cd $KERNEL_DIR
}

case $1 in
clean)
make ARCH=arm64 -j8 clean mrproper
rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
;;
*)
compile_kernel
;;
esac

rm -rf $OUT_DIR/Xzotic*.zip
rm -rf $OUT_DIR/modules/*
rm -rf $OUT_DIR/dt.img
rm -rf $OUT_DIR/zImage
cp $KERNEL_DIR/arch/arm64/boot/Image  $OUT_DIR/tools/zImage
cp $KERNEL_DIR/arch/arm64/boot/dt.img  $OUT_DIR/tools/dt.img
cp $MODULES_DIR/*.ko $OUT_DIR/modules/
cd $OUT_DIR
zip -r Xzotic-Kernel-R6.zip *
cd $KERNEL_DIR

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo -e "$cyan**************************************************************************"
echo "+               ▒██   ██▒▒███████▒ ▒█████  ▄▄▄█████▓ ██▓ ▄████▄          +"
echo "+               ▒▒ █ █ ▒░▒ ▒ ▒ ▄▀░▒██▒  ██▒▓  ██▒ ▓▒▓██▒▒██▀ ▀█          +" 
echo "+               ░░  █   ░░ ▒ ▄▀▒░ ▒██░  ██▒▒ ▓██░ ▒░▒██▒▒▓█    ▄         +" 
echo "+                ░ █ █ ▒   ▄▀▒   ░▒██   ██░░ ▓██▓ ░ ░██░▒▓▓▄ ▄██▒        +" 
echo "+               ▒██▒ ▒██▒▒███████▒░ ████▓▒░  ▒██▒ ░ ░██░▒ ▓███▀ ░        +" 
echo "+               ▒▒ ░ ░▓ ░░▒▒ ▓░▒░▒░ ▒░▒░▒░   ▒ ░░   ░▓  ░ ░▒ ▒  ░        +" 
echo "+               ░░   ░▒ ░░░▒ ▒ ░ ▒  ░ ▒ ▒░     ░     ▒ ░  ░  ▒           +" 
echo "+                ░    ░  ░ ░ ░ ░ ░░ ░ ░ ▒    ░       ▒ ░░                +" 
echo "+                ░    ░    ░ ░        ░ ░            ░  ░ ░              +" 
echo "+                ░                              ░                        +" 
echo -e "**************************************************************************$cyan"
