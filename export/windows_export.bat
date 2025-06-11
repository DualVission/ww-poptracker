@echo off

set arg1=%1
set arg2=%2
::This batch script will zip the contents of the folders
::Accepts arguments for export path
::Users can usk shortcut .LNK files to pass these arguments easily
::Older version and files not necessary for the pack to function are omited

::windows_export.bat [end file path] [skip user input on completion]

::Prerequesites
::-Windows
::-7-Zip

if NOT exist "C:\Program Files\7-Zip\7z.exe" (
    (echo No version of 7-Zip was located in your program files. Please install 7-Zip and try again.)
    (set /p error=Press enter to exit window.)
    (goto eof)
)
::Check if 7-Zip is installed
::Alert the user of error and wait for input
::Exit script

set packname=ww-poptracker.zip
::Store packname as string

cd %~dp0..
::Change the directory to the file location, but up one folder
::This should always be the root of the project
::If this is not done, it will attempt to grab the entire drive
::Luckily, this will fail

echo %arg1%
if NOT "%arg1%"=="" (
    (set efl="%1\%packname%")
    (goto ZipContents)
)
::If an argument is passed
::Set the end file location to the argument with packname
::Skip to next section

set efl="%~dp0\%packname%"
::Set the end of file location to the export folder with packname

:ZipContents

echo Exporting contents to "%efl%".
if exist %efl% (
    (echo Older version detected. Deleting "%efl%".)
    (del %efl% 2>NUL)
    (echo Exporting contents to "%efl%".)
)
::If an older version is detected at the end location
::Alert the user that file is being deleted
::If this is not done, 7-Zip does not permit itself to overwrite existing compressed .ZIP files

"C:\Program Files\7-Zip\7z.exe" a %efl% -xr!*.bat -xr!.git* -xr!*.git -xr!*/.unused* -xr!*.sublime* -xr!*.zip -xr!*/.idea* -xr!*.lnk -xr!/export*
::Call 7-Zip to export the .ZIP to desired end file location
::Passing a bunch of arguments to say "not these things"

if "%arg2%"=="" (
    (set /p eof=)
)
::If a second argument is not passed
::Wait for user input to close