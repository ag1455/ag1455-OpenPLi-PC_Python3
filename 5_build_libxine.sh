#!/bin/bash

OLDDEB="libxine2"
dpkg -s $OLDDEB | grep -iw ok > /dev/null

# Remove old package DEBxine2
if [ $? -eq 0 ]; then
	apt-get -y purge $OLDDEB*
else
	echo "$OLDDEB not installed"
fi

# Case failure
if [[ -f xine-lib* ]]; then
	rm -rf xine-lib*
fi

release=$(lsb_release -a 2>/dev/null | grep -i release | awk ' { print $2 } ')

if [[ "$release" = "20.04" ]]; then
	PKG="xine-lib-1.2.9"
	PKG1="xine-lib-1.2_1.2.9"
	DEB="xine-lib-1.2_1.2.9-1build5.debian.tar.xz"
	# This is release 1.2.9
	wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/xine-lib-1.2/1.2.9-1build5/$PKG1.orig.tar.xz
	wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/xine-lib-1.2/1.2.9-1build5/$DEB
fi

if [[ "$release" = "22.04" ]]; then
	PKG="xine-lib-1.2.11"
	PKG1="xine-lib-1.2_1.2.11"
	DEB="xine-lib-1.2_1.2.11-2.debian.tar.xz"
	# This is release 1.2.11
	wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/xine-lib-1.2/1.2.11-2/$PKG1.orig.tar.xz
	wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/xine-lib-1.2/1.2.11-2/$DEB
fi

if [[ "$release" = "23.04" ]]; then
	PKG="xine-lib.1.2.13"
	PKG1="xine-lib-1.2_1.2.13"
	DEB="xine-lib-1.2_1.2.13-1.debian.tar.xz"
	# This is release 1.2.13
	wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/xine-lib-1.2/1.2.13-1/$PKG1.orig.tar.xz
	wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/xine-lib-1.2/1.2.13-1/$DEB
fi

if [ -f $PKG1.orig.tar.xz ]; then
	# Remove old source DEBxine2
	if [[ -d $PKG ]]; then
		rm -rf $PKG
	fi
	tar -xf $PKG1.orig.tar.xz
	rm $PKG1.orig.tar.xz
	mv $DEB $PKG
	cp -fv patches/$PKG+e2pc.patch $PKG
	cd $PKG
	tar -xf $DEB
	rm $DEB
	patch -p1 < $PKG+e2pc.patch
	echo "-----------------------------------------"
	echo "       patch for xine-lib applied"
	echo "-----------------------------------------"
	dpkg-buildpackage -b -d -uc -us
	cd ..
	dpkg -i *.deb
	mv *.deb *.ddeb *.changes *.buildinfo $PKG
else
	echo "-----------------------------------------"
	echo "        CHECK INTERNET CONNECTION!"
	echo "-----------------------------------------"
fi
