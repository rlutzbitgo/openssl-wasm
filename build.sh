#!/bin/bash

echo "Downloading openssl 3.1"
curl -s https://www.openssl.org/source/openssl-3.1.0.tar.gz -o openssl-3.1.0.tar.gz
echo "Verifying checksum"
echo "aaa925ad9828745c4cad9d9efeb273deca820f2cdcf2c3ac7d7c1212b7c497b4  openssl-3.1.0.tar.gz" | sha256sum -c
if [ $? -ne 0 ]; then
  echo "Could not verify checksum"
  exit 1
fi
tar xzf openssl-3.1.0.tar.gz

echo "Downloading wasmer toolchain"
rm -rf ~/.wasmer
curl https://get.wasmer.io -sSfL | sh
source ~/.wasmer/wasmer.sh
curl https://raw.githubusercontent.com/wasienv/wasienv/master/install.sh | sh
source ~/.wasienv/wasienv.sh

echo "Patching openssl"
patch openssl-3.1.0/crypto/bio/bss_log.c patches/bss_log.c.patch
patch openssl-3.1.0/apps/speed.c patches/speed.c.patch
patch openssl-3.1.0/crypto/rand/rand_lib.c patches/rand_lib.c.patch
patch openssl-3.1.0/crypto/mem_sec.c patches/mem_sec.c.patch

echo "Patch complete"
echo "Beginning configuration of wasm openssl..."
cd openssl-3.1.0
wasiconfigure ./Configure gcc -no-tests -no-asm -static -no-sock -no-afalgeng -DOPENSSL_SYS_NETWARE -DSIG_DFL=0 -DSIG_IGN=0 -DHAVE_FORK=0 -DOPENSSL_NO_AFALGENG=1 --with-rand-seed=getrandom
sed -i 's/^CROSS_COMPILE=.*/CROSS_COMPILE=/g' Makefile
wasimake make
