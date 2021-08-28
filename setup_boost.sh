#!/bin/bash

set -e

VERSION="$1"
BOOST_ROOT="$2"

VUNDER="${VERSION//./_}"

TEMP_ARCHIVE="$(mktemp)"

set -x

mkdir -p "$BOOST_ROOT"

curl -L -o "$TEMP_ARCHIVE" "https://boostorg.jfrog.io/artifactory/main/release/${VERSION}/source/boost_${VUNDER}.tar.bz2"

tar -j -x -C "$BOOST_ROOT" -f "$TEMP_ARCHIVE" --strip-components 1
rm "$TEMP_ARCHIVE"

cd "$BOOST_ROOT"

case $OSTYPE in
*[Dd]arwin*)
	BOOTSTRAP=./bootstrap.sh
	;;
*[Ww]in*)
	BOOTSTRAP=./bootstrap.bat
	;;
*)
	BOOTSTRAP=./bootstrap.sh
	;;
esac

$BOOTSTRAP

cat ./project-config.jam

./b2 -j20 headers
