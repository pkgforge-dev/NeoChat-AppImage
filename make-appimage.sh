#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q neochat | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.kde.neochat.svg
export DESKTOP=/usr/share/applications/org.kde.neochat.desktop
export STARTUPWMCLASS=org.kde.neochat
export USE_HOST_DRIVERS_EXPERIMENTAL=1
export DEPLOY_PULSE=1

# Deploy dependencies
quick-sharun /usr/bin/neochat \
  /usr/lib/qt6/plugins/kf6/purpose/neochatshareplugin.so \
  /usr/lib/libKF6Notifications.so* \
  /usr/lib/libKirigami*.so* \
  /usr/share/icons/hicolor/scalable/apps/org.kde.neochat.tray.svg

echo 'ANYLINUX_DO_NOT_LOAD_LIBS=libpipewire-0.3.so*:${ANYLINUX_DO_NOT_LOAD_LIBS}' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
