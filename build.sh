#!/bin/sh bash

while getopts "hvf:" flag; do
 case $flag in
   h) echo " "
      echo "BootIMG Packer - Boot img packer for Custom recoveries."
      echo " "
      echo "Author: github.com/isg32 "
      echo " "
      echo "Usage: "
      echo " - Place your Bootimg in img folder"
      echo " - In the main dir, run bash build.sh "
      echo " - Enter Your device Name "
      echo " - Let the script build  "
      echo " "
      echo " Voila, U have your flashable KSU "
      echo " "
      exit 0
   ;;
   \?)
   # Handle invalid options
   ;;
 esac
done

echo " "

read -p "Enter Your BootType - KSU/Magisk/ETC. : " BOOT

read -p "Enter Your device: " DEVICE
echo " "
echo "[OKAY]"
echo " "
echo -e "\nBuilding Flashable $BOOT for $DEVICE"

echo """ 
==============================================
    Sit back and chill, imma build for u
==============================================
"""

echo " "
echo "- initial dump"

# Moving boot img

cd img
cp ***.img ../Template/update/boot.img
cd ..

echo "- Script dump"
sleep 0.5

# Build Script dump to temp file
echo """
show_progress(0.200000, 10);
ui_print(" "); 
ui_print(" Flashing $BOOT for $DEVICE"); 
ui_print("============================"); 
ui_print(" "); 
ui_print("Installing Images..."); 
ui_print(" ");
ui_print("In Slot a and b");
ui_print("--- ");
package_extract_file("update/boot.img", "/dev/block/bootdevice/by-name/boot_a");
package_extract_file("update/boot.img", "/dev/block/bootdevice/by-name/boot_b");
ui_print(" ");
ui_print("Done!");
ui_print(" ");

show_progress(0.100000, 2);
set_progress(1.000000);
 """ > buildscript

echo "- Building Script"
sleep 0.5
# Move to actual binary
mv buildscript Template/META-INF/com/google/android/updater-script

sleep 0.5
echo "- Removing temp files"
# Delete temp file
rm -fr buildscript

echo "- Building zip"
echo " "
echo "=============================================="
echo " "
cd Template
zip -r $BOOT-$(date '+%d%m%Y')-$DEVICE.zip *
mv $BOOT-$(date '+%d%m%Y')-$DEVICE.zip ../
cd ..
echo " "
echo "- Zip Done"

sleep 1
echo "=============================================="
echo " "
echo ">> Done!"
echo " "
