# Script Pack Kernel + Ramdisk and CWM zip + sign 
# By Adi_Pat
# Modified By dlhxr
tput setaf 6
setterm -bold 
echo "**** KERNEL PACKER SCRIPT ****"
echo "**** FOR I9250 ****"
echo "**** By Adi_Pat ****"
echo "**** Modified By dlhxr ****"
tput sgr0 
setterm -bold
echo "Checking zImage in kernel/zImage"
if test -e kernel/zImage
   then echo "zImage found"
else echo "Kernel not found!"
   tput sgr0
   exit 
fi
echo "Checking Ramdisk"
if test -d ramdisk 
then echo "Ramdisk found" 
else echo "Ramdisk not found!"
tput sgr0
exit 
fi
echo "Checking Parameter"
if test -d parameter 
then echo "Parameter found" 
else echo "Parameter not found!"
tput sgr0
exit 
fi

echo "zImage + ramdisk + parameter found, preparing ramdisk"
sleep 2 
rm -rf ./out
./tools/mkbootfs ramdisk | gzip > ramdisk.gz
sleep 2
echo "Packing final Kernel (boot.img) "
mkdir -p out
./tools/mkbootimg --kernel kernel/zImage --ramdisk ramdisk.gz -o out/2nd.img --base 0x$(cat parameter/base) --pagesize $(cat parameter/pagesize) --cmdline "$(cat parameter/cmdline)"
sleep 2
setterm -bold 
rm ramdisk.gz
s1=`ls -lh boot.img | sed -e 's/.* [ ]*\([0-9]*\.[0-9]*[MK]\) .*/\1/g'`
cd out 
s2=`ls -lh 2nd.img | sed -e 's/.* [ ]*\([0-9]*\.[0-9]*[MK]\) .*/\1/g'`
tput setaf 3
echo "Size of old boot.img: $s1"
echo "Size of new 2nd.img: $s2"
tput setaf 1 
echo "Final 2nd.img is in out/2nd.img"
tput sgr0
echo "All Done, press enter to exit"
read ANS
