#!/bin/sh

set -xe

DIR_TMP="$(mktemp -d)"
QBIT_VERSION="4.6.5.10"

OS_type="$(uname -m)"
case "$OS_type" in
x86_64 | amd64)
  OS_type2='x86_64-linux-musl_static'
  OS_type3='amd64'
  ;;
aarch64 | arm64)
  OS_type2='aarch64-linux-musl_static'
  OS_type3='arm64'
  ;;
arm*)
  OS_type2='arm-linux-musleabihf_static'
  OS_type3='armhf'
  ;;
*)
  echo 'OS type not supported'
  exit 2
  ;;
esac

# Install qBit
wget -P ${DIR_TMP} https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/release-${QBIT_VERSION}/qbittorrent-enhanced-nox_${OS_type2}.zip
busybox unzip ${DIR_TMP}/qbit*
install -m 755 ./qbittorrent-nox /usr/bin/qbittorrent-nox

# Install Aria2
wget -O - https://github.com/P3TERX/Aria2-Pro-Core/releases/download/1.36.0_2021.08.22/aria2-1.36.0-static-linux-${OS_type3}.tar.gz | tar -zxf - -C /usr/bin

rm -rf ${DIR_TMP}