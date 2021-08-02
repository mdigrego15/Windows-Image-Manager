# Windows-Imaging-Solution

This batch script uses DISM to create and apply custom windows images within a WinPE environment

To use the script, all you need to do is have a bootable WinPE drive with a formatted partition to store the images. The script can both capture and apply Windows Images with a .WIM file type.

TO use this script with an existing WinPE media, replace the startnet.cmd file in Windows\System32 on the WinPE partition.

Resources for creating the WinPE media:
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe--use-a-single-usb-key-for-winpe-and-a-wim-file---wim
