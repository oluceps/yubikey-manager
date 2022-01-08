#!/bin/bash
# Script to produce an OS X installer .pkg

set -e

CWD=`pwd`
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SOURCE_DIR="$CWD/ckman"
RELEASE_VERSION=`$SOURCE_DIR/ckman --version | awk '{print $(NF)}'`

if [ -z "$1" ]
then
	PKG="ckman.pkg"
else
	PKG="$1"
fi

echo "Release version : $RELEASE_VERSION"
echo "Binaries: $SOURCE_DIR"

set -x

cd $SCRIPT_DIR

mkdir -p pkg/root/usr/local/bin pkg/comp
cp -r $SOURCE_DIR pkg/root/usr/local/
(cd pkg/root/usr/local/bin && ln -s ../ckman/ckman)

pkgbuild --root="pkg/root" --identifier "org.canokeys.canokey-manager" --version "$RELEASE_VERSION" "pkg/comp/ckman.pkg"

productbuild  --package-path "pkg/comp" --distribution "distribution.xml" "$PKG"

# Move to dist
mv $PKG $CWD/$PKG

# Clean up
rm -rf pkg
