#!/bin/sh

echo
echo '>>> ssp_nonshared'
echo

clang -c $SOURCES/__stack_chk_fail_local.c -o $SOURCES/__stack_chk_fail_local.o
ar r libssp_nonshared.a $SOURCES/__stack_chk_fail_local.o
mv libssp_nonshared.a $SYSROOT/usr/lib/libssp_nonshared.a
