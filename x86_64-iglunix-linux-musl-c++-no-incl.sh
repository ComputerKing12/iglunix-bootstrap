#!/bin/sh -e
SYSROOT=$(realpath $(dirname $0))/sysroot/
clang++-18 --sysroot=$SYSROOT --target=x86_64-linux-musl \
-nostdinc++ \
-rtlib=compiler-rt -stdlib=libc++ -unwindlib=libunwind \
-Wno-unused-command-line-argument -fuse-ld=lld \
"$@"
