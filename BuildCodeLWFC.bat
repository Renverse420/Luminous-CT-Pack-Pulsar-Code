
SETLOCAL EnableDelayedExpansion
@echo off
cls
del build\*.o

SET "debug="
SET "cwDWARF="
if "%1" equ "-d" SET "debug=-debug -map=^"C:\Users\admin\Documents\Dolphin Emulator\Maps\RMCP01.map^" -readelf=^"C:\MinGW\bin\readelf.exe^""
if "%1" equ "-d" SET "cwDWARF=-g"


:: Destination (change as necessary)
SET "SOURCE=Pulsar"
SET "RIIVO=C:\Users\rajwi\Desktop\Dolphin-x64\User\Load\Riivolution\Luminousv7"
SET "ENGINE=C:\Users\rajwi\Desktop\pulsarcode\KamekInclude"
SET "CREATOR=C:\Users\rajwi\Desktop\pulsarcode\PulsarPackCreator\Resources"
echo %RIIVO%


:: CPP compilation settings
SET CC="mwcceppc.exe"
SET CFLAGS=-I- -i "C:\Users\rajwi\Desktop\pulsarcode\KamekInclude" -i "C:\Users\rajwi\Desktop\pulsarcode\GameSource" -i "C:\Users\rajwi\Desktop\pulsarcode\GameSource\MarioKartWii" -i PulsarEngine ^
  -opt all -inline auto -enum int -proc gekko -fp hard -sdata 0 -sdata2 0 -maxerrors 1 -func_align 4 %cwDWARF%
SET DEFINE=

:: CPP Sources
SET CPPFILES=
for /R PulsarEngine %%f in (*.cpp) do SET "CPPFILES=%%f !CPPFILES!"

:: Compile CPP
%CC% %CFLAGS% -c -o "build/kamek.o" "%ENGINE%\kamek.cpp"

SET OBJECTS=
FOR %%H IN (%CPPFILES%) DO (
    ::echo "Compiling %%H..."
    %CC% %CFLAGS% %DEFINE% -c -o "build/%%~nH.o" "%%H"
    SET "OBJECTS=build/%%~nH.o !OBJECTS!"
)

:: Link
echo Linking... %time%
"Kamek.exe" "build/kamek.o" %OBJECTS% %debug% -dynamic -externals="C:\Users\rajwi\Desktop\pulsarcode\GameSource\symbols.txt" -versions="C:\Users\rajwi\Desktop\pulsarcode\GameSource\versions.txt" -output-combined=build\CodeLWFC.pul

if %ErrorLevel% equ 0 (
    xcopy /Y build\*.pul "%RIIVO%\Binaries" >nul
    xcopy /Y build\*.pul "%CREATOR%" >nul
    echo Binaries copied
)

:end
ENDLOCAL
PAUSE