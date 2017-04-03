#!/bin/bash
#
#Xzotic build script
#
# Copyright © 2017, As007 "AkashPathange7 a.k.a As007" <akashpathange.aaa47@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details

# colors
white="\e[1;37m"
green="\e[1;32m"
red="\e[1;31m"
magenta="\e[1;35m"
cyan="\e[1;36m"
yellow="\e[1;33m"
blue="\e[1;34m"
restore="\e[0m"
blink_red="\e[05;31m"
bold="\e[1m"
invert="\e[7m"
nocol='\033[0m'

# Paths
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/dtbTool
MODULES_DIR=/home/as007/xzotic/COMMON
OUT_DIR=/home/as007/xzotic/XZOTIC
BUILD_START=$(date +"%s")

# Modify the following variable if you want to build
echo -e "${bold}${blue}"
echo "--------------------"
echo "Making XzoTic Kernel:"
echo "--------------------"
echo -e "${restore}"

echo -e "${bold}${white}"
while read -p "Do you want to use Linaro 4.9(1) or Linaro 6.3.1(2)? " echoice
do
case "$echoice" in
	1 )
		export CROSS_COMPILE=~/android-kernel/aarch64-linux-android-4.9-linaro-kernel/bin/aarch64-linux-android-
		TC="Linaro 4.9"
		echo
		echo "Using Linaro 4.9"
		break
		;;
	2 )
		export CROSS_COMPILE=~/android-kernel/aarch64-6.3/bin/aarch64-
		TC="Linaro 6.3.1"
		echo
		echo "Using Linaro 6.3.1"
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done
echo -e ""
echo -e "$yellow-----------------"
echo -e "   COMPILING    "
echo -e "-----------------$yellow $nocol"
echo -e ""
export ARCH=arm64
export SUBARCH=arm64
export USE_CCACHE=1
export KBUILD_BUILD_USER=AkashPathange
export KBUILD_BUILD_HOST=NaHCO3

compile_kernel ()
{
make lineageos_lettuce_defconfig
make -j8
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
echo -e ""
echo -e ""
echo -e "${bold}${cyan}-----------------"
echo -e "     DT.IMG       "
echo -e "-----------------${bold}${cyan} $nocol"
echo -e ""
echo -e "${white}"
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
strip_modules
}

strip_modules ()
{
echo -e "${white}"
echo "Copying modules"
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

#Zipping_Department
{
echo -e "${magenta}${bold}"
echo "-----------------------------------------------"
echo "HOLD YOUR BREATH FOR A WHILE"
echo "                             IT'S ZIPPING               "
echo "-----------------------------------------------"
echo -e "${magenta}${bold} $nocol"
}
{
echo -e "${white}"
rm -rf $OUT_DIR/Xzotic*.zip
rm -rf $OUT_DIR/modules/*
rm -rf $OUT_DIR/dt.img
rm -rf $OUT_DIR/zImage
cp $KERNEL_DIR/arch/arm64/boot/Image  $OUT_DIR/tools/zImage
cp $KERNEL_DIR/arch/arm64/boot/dt.img  $OUT_DIR/tools/dt.img
cd $OUT_DIR
zip -r Xzotic-Kernel-R6.2.zip *
cd $KERNEL_DIR
echo -e "${white}${bold}$nocol"
}

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "${blink_red}${bold} Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
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
