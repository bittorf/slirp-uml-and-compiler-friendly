#!/bin/sh

OPTION="$1"	# <empty> or 'quiet'

die()
{
	echo
	echo "# [ERROR] see folder '$FOLDER' and '$( pwd )' - aborting"
	exit 1
}

download()
{
	BASE="$( basename "$URL" )"

	if [ -f "$GITBASE/$BASE" ]; then
		cp -v "$GITBASE/$BASE" "$BASE" || die
	else
		wget --no-check-certificate -O "$BASE" "$URL" || die
	fi
}

GITBASE="$( pwd )"
FOLDER="$( mktemp -d )" || {
	FOLDER="foo.$$"
	mkdir "$FOLDER" || die
}
cd "$FOLDER" || die
echo "# [OK] working in folder: '$FOLDER'"

# URL='http://deb.debian.org/debian/pool/main/s/slirp/slirp_1.0.17.orig.tar.gz'
URL='https://github.com/bittorf/slirp-uml-and-compiler-friendly/raw/main/slirp_1.0.17.orig.tar.gz'
download
tar xzf "$BASE"			# folder 'slirp_1.0.17'

# URL='http://deb.debian.org/debian/pool/main/s/slirp/slirp_1.0.17-11.debian.tar.xz'
URL='https://github.com/bittorf/slirp-uml-and-compiler-friendly/raw/main/slirp_1.0.17-11.debian.tar.gz'
download
tar xzf "$BASE"			# folder 'debian'

cd ./*.17 || die

RC=0
for FILE in ../debian/patches/*.patch; do echo "# $FILE"; patch -p1 <"$FILE" && continue; RC=1; echo "# RC = 1"; done
test $RC -eq 0 || die

cd src || die
./configure || die
[ "$OPTION" = 'quiet' ] && { sed -i 's|\(^.*lprint("\).*\(".*\)|\1\2|' main.c || exit; }
echo '#define FULL_BOLT' >>config.h 
sed 's/^CFLAGS .*/& -std=gnu89/' Makefile >Makefile.patched || die
cp -v Makefile.patched Makefile || die

make || die

strip -o slirp.stripped slirp
strip -o slirp.stripped_full -s slirp

echo
echo "# [OK] everything worked, see folder '$FOLDER' and '$PWD'"
ls -l slirp slirp.*

BIN="$PWD/slirp"
[ -x "$BIN" ] && echo "SLIRP_BIN='$BIN'"
