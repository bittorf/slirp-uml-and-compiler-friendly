#!/bin/sh

die() { echo; echo "# [ERROR] see folder '$FOLDER' and '$( pwd )' - aborting"; exit 1; }

FOLDER="$( mktemp -d )" || die
cd "$FOLDER" || die
echo "# [OK] working in folder: '$FOLDER'"

URL='http://deb.debian.org/debian/pool/main/s/slirp/slirp_1.0.17.orig.tar.gz'
BASE="$( basename "$URL" )"
wget -O "$BASE" "$URL" || die
tar xzf "$BASE"			# folder 'slirp_1.0.17'

URL='http://deb.debian.org/debian/pool/main/s/slirp/slirp_1.0.17-11.debian.tar.xz'
BASE="$( basename "$URL" )"
wget -O "$BASE" "$URL" || die
tar xJf "$BASE"			# folder 'debian'

cd ./*.17 || die
RC=0
for FILE in ../debian/patches/*.patch; do echo "# $FILE"; patch -p1 <"$FILE" && continue; RC=1; echo "# RC = 1"; done
test $RC -eq 0 || die

cd src || die
./configure || die
echo '#define FULL_BOLT' >>config.h 
sed -i 's/^CFLAGS .*/& -std=gnu89/' Makefile || exit

make || die

strip -o slirp.stripped slirp
strip -o slirp.stripped_full -s slirp

echo
echo "# [OK] everything worked, see folder '$FOLDER' and '$( pwd )'"
ls -l slirp slirp.*

