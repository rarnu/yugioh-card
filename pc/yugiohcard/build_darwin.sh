#!/bin/sh

TYPHON_ROOT=/usr/local/codetyphon
FPC=${TYPHON_ROOT}/fpc/fpc64/bin/x86_64-darwin/fpc
TYPHON=${TYPHON_ROOT}/typhon
FW=/System/Library/Frameworks
ARCH=x86_64-darwin

rm -fr MasterText.app
rm -fr ../release/MasterText.app

mkdir -p build/${ARCH}

# compile
${FPC} -MObjFPC -Scghi -O1 -gw -gl -l -vewnhibq  \
	-k-framework -kCarbon -k-framework -kOpenGL \
	-k-dylib_file -k${FW}/OpenGL.framework/Versions/A/Libraries/libGL.dylib:${FW}/OpenGL.framework/Versions/A/Libraries/libGL.dylib \
	-Fibuild/${ARCH} \
	-FUbuild/${ARCH} \
	-Fu. \
	-Fu${TYPHON}/lcl/units/${ARCH}/carbon \
	-Fu${TYPHON}/lcl/units/${ARCH} \
    -Fu${TYPHON}/components/pl_RichMemo/lib/${ARCH}/carbon \
	-Fu${TYPHON}/components/BaseUtils/lib/${ARCH} \
	-Fu${TYPHON}/packager/units/${ARCH} \
	-dLCL -dLCLcarbon \
	MasterText.ppr

strip MasterText

# bundle
mkdir MasterText.app
mkdir MasterText.app/Contents
mkdir MasterText.app/Contents/MacOS
mkdir MasterText.app/Contents/MacOS/images/
mkdir MasterText.app/Contents/Resources
cp PkgInfo MasterText.app/Contents/PkgInfo
cp Info.plist MasterText.app/Contents/Info.plist
mv MasterText MasterText.app/Contents/MacOS/
cp mfcross/mac/libmfcross32.dylib MasterText.app/Contents/MacOS/
cp mfcross/mac/clct MasterText.app/Contents/MacOS/
# cp -r ltool MasterText.app/Contents/MacOS/
cp -r images MasterText.app/Contents/MacOS/
cp default.jpg MasterText.app/Contents/MacOS/images/
cp MasterText.icns MasterText.app/Contents/Resources/

mv MasterText.app ../release/

