#!/bin/bash

PACKAGE="tarsnap"
ARCH="amd64"
VERSION="1.0.35"

echo "Fetching latest copy of $PACKAGE..."
wget --quiet https://www.tarsnap.com/download/$PACKAGE-autoconf-$VERSION.tgz

echo "Extracting download..."
tar -zxvf $PACKAGE-autoconf-$VERSION.tgz > /dev/null 2>&1
mv $PACKAGE-autoconf-$VERSION tmp

echo "Compiling..."
mkdir /tmp/$PACKAGE-installdir
cd tmp
./configure > /dev/null 2>&1
make all install clean DESTDIR=/tmp/$PACKAGE-installdir > /dev/null 2>&1

echo "Packaging..."
cd ..
fpm \
  --vendor "Colin Percival <cperciva@tarsnap.com>" \
  --maintainer "Matthew Gall <repo@matthewgall.com>" \
  --url "https://tarsnap.com" \
  --description "Tarsnap is a secure online backup service for BSD, Linux, OS X, Minix, OpenIndiana, Cygwin, and probably many other UNIX-like operating systems. The Tarsnap client code provides a flexible and powerful command-line interface which can be used directly or via shell scripts." \
  -s dir \
  -t deb \
  -n $PACKAGE \
  -v $VERSION \
  -C /tmp/$PACKAGE-installdir \
  -p $PACKAGE-VERSION_ARCH.deb usr > /dev/null 2>&1

echo "Cleaning up..."
rm -rf tmp /tmp/$PACKAGE-installdir
rm -rf *.tgz
