@echo off
echo ==============================================
echo Generating Assets for all Flavors...
echo ==============================================

echo [US] Generating Icons and Splash...
call flutter pub run flutter_launcher_icons -f flutter_launcher_icons_us.yaml
call flutter pub run flutter_native_splash:create --path=flutter_native_splash_us.yaml

echo [UK] Generating Icons and Splash...
call flutter pub run flutter_launcher_icons -f flutter_launcher_icons_uk.yaml
call flutter pub run flutter_native_splash:create --path=flutter_native_splash_uk.yaml

echo [DE] Generating Icons and Splash...
call flutter pub run flutter_launcher_icons -f flutter_launcher_icons_de.yaml
call flutter pub run flutter_native_splash:create --path=flutter_native_splash_de.yaml

echo [AU] Generating Icons and Splash...
call flutter pub run flutter_launcher_icons -f flutter_launcher_icons_au.yaml
call flutter pub run flutter_native_splash:create --path=flutter_native_splash_au.yaml

echo [FR] Generating Icons and Splash...
call flutter pub run flutter_launcher_icons -f flutter_launcher_icons_fr.yaml
call flutter pub run flutter_native_splash:create --path=flutter_native_splash_fr.yaml

echo ==============================================
echo Done! All flavor assets generated.
echo ==============================================
