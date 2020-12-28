# slirp-uml-and-compiler-friendly

## overview ##

This downloads all debian SLiRP-related files, applies the patches,
adds some more patches, compiles in FULL_BOLT mode and
strips the resulting binaries.

## manual steps ##

manual search:
debian + slirp + sid + source

url:
https://packages.debian.org/source/sid/net/slirp

## tested with ##
```
gcc (Debian 10.2.1-1) 10.2.1 20201207
gcc (Debian 8.3.0-6) 8.3.0
gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516
gcc (Debian 4.7.2-5) 4.7.2
gcc (Debian 2.7.2.1)		** failing **
gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3
gcc (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291]
```
