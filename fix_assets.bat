@echo off
setlocal enabledelayedexpansion

set FLAVORS=us uk de au fr

for %%f in (%FLAVORS%) do (
    echo Processing Flavor: %%f
    
    :: 1. Generate icons for this flavor (it will put them in main/res)
    call flutter pub run flutter_launcher_icons -f flutter_launcher_icons_%%f.yaml
    
    :: 2. Create the flavor res directory if it doesn't exist
    if not exist android\app\src\%%f\res mkdir android\app\src\%%f\res
    
    :: 3. Move mipmap folders from main to the flavor res
    echo Moving icons to android/app/src/%%f/res...
    for /d %%d in (android\app\src\main\res\mipmap-*) do (
        set DIRNAME=%%~nxd
        if not exist android\app\src\%%f\res\!DIRNAME! mkdir android\app\src\%%f\res\!DIRNAME!
        move /y %%d\*.png android\app\src\%%f\res\!DIRNAME!\
    )

    :: 4. Process Splash for this flavor
    echo Generating Splash for %%f...
    call flutter pub run flutter_native_splash:create --path=flutter_native_splash_%%f.yaml
    
    :: 5. Move splash drawable folders from main to flavor res
    echo Moving splash to android/app/src/%%f/res...
    if exist android\app\src\main\res\drawable mkdir android\app\src\%%f\res\drawable
    if exist android\app\src\main\res\drawable-v21 mkdir android\app\src\%%f\res\drawable-v21
    
    if exist android\app\src\main\res\drawable\launch_background.xml move /y android\app\src\main\res\drawable\launch_background.xml android\app\src\%%f\res\drawable\
    if exist android\app\src\main\res\drawable-v21\launch_background.xml move /y android\app\src\main\res\drawable-v21\launch_background.xml android\app\src\%%f\res\drawable-v21\
    
    :: Also move the splash image if it was created in drawable
    if exist android\app\src\main\res\drawable\splash.png move /y android\app\src\main\res\drawable\splash.png android\app\src\%%f\res\drawable\
)

echo Done! All assets have been manually flavored and moved.
