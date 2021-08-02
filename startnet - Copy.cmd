wpeinit
@echo off
goto :choosedisk

:start
set /p choice="Would you like to capture an image, apply an image or backup a user folder(capture/apply/backup)? "
if /i "%choice%" == "capture" goto :prep
if /i "%choice%" == "apply" goto :clean
if /i "%choice%" == "backup" goto :prep
else goto eof

:choosedisk
@echo off
echo Please select the target disk.
(echo list disk & echo exit) | diskpart
echo.
:loop
set /p disk="Which disk is the target drive [x to exit]? "
if "%disk%"=="0" goto :next1
if "%disk%"=="1" goto :next1
if "%disk%"=="2" goto :next1
if "%disk%"=="3" goto :next1
if "%disk%"=="4" goto :next1
if "%disk%"=="5" goto :next1
if "%disk%"=="6" goto :next1
if "%disk%"=="7" goto :next1
if "%disk%"=="8" goto :next1
if "%disk%"=="9" goto :next1
if "%disk%"=="x" goto :eof
echo.
echo Invalid disk. & goto :loop
:next1
echo Please select the WinPE drive.
(echo list disk & echo exit) | diskpart
echo.
:loop2
set /p winpe="Which disk is the WinPE drive? [x to exit]"
if /i "%winpe%" == "%disk%" echo The WinPE disk cannot be the same as the target disk. & goto :loop2
if "%winpe%"=="0" goto :next2
if "%winpe%"=="1" goto :next2
if "%winpe%"=="2" goto :next2
if "%winpe%"=="3" goto :next2
if "%winpe%"=="4" goto :next2
if "%winpe%"=="5" goto :next2
if "%winpe%"=="6" goto :next2
if "%winpe%"=="7" goto :next2
if "%winpe%"=="8" goto :next2
if "%winpe%"=="9" goto :next2
if "%winpe%"=="x" goto :eof
echo.
echo Invalid disk. & goto :loop2
:next2
goto :start

:capture
@echo off
cls
set /p x="Image Name: "
dism.exe /capture-image /imagefile:"D:\Images\%x%.wim" /CaptureDir:C:\ /name:%x%
goto :eof

:apply
@echo off
cls
dir D:\Images /b /d
set /p x="Which Image? "
(echo select disk %disk%
echo clean
echo convert gpt
echo create partition efi size=500
echo format fs=FAT32 quick label=system
echo assign letter=s
echo create partition primary 
echo select partition 2
echo format fs=ntfs quick label=windows
echo assign letter=w) | diskpart
if /i not exist D:\Images\%x%.wim goto :error
dism /apply-image /imagefile:"D:\Images\%x%.wim" /index:1 /ApplyDir:W:\
w:\windows\system32\bcdboot w:\windows /s S: /f UEFI
goto :eof

:error
echo No file with that name. Choose from the list displayed above.
goto :apply

:clean
set /p check = Target drive will be overwritten. Would you like to proceed (y/n)?
if /i "%check%" == "y" goto :continue
if /i "%check%" == "n" goto :eof
:continue
(echo select disk %disk%
echo clean
echo select disk %winpe%
echo select partition 1
echo assign letter=p
echo select partition 2
echo assign letter=d) | diskpart
goto :apply

:prep
(echo select disk %winpe%
echo select partition 1
echo assign letter=p
echo select partition 2
echo assign letter=d) | diskpart
if %choice% == backup goto :backup
goto :capture

:backup
if exist C:\Users goto continueBackup
echo The script was unable to automatically detect the local Windows Partition. This could be due to an unexpected Recovery Partition.
echo .
(echo select disk %disk% & echo list partition) | diskpart
set /p "partition" = "Select the primary Windows Partition on the drive (it should be the largest one) "
(echo select disk %disk%
echo select partition %partition% 
echo assign letter=c) | diskpart
goto :backup

:continueBackup
dir C:\Users /b /d
set /p c="Which user folder would you like to backup?"
robocopy C:\Users\%c% D:\Backup\%c% /MIR /R:5 /W:1 /xj
goto :start
