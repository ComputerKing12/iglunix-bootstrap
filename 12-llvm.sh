#!/bin/sh -e
[ -f "$REPO_ROOT/.llvm" ] && exit 0

cd "$BUILD"
mkdir -p llvm
cd llvm

set +e

ls -l $BUILD/tblgen/bin/
file $BUILD/tblgen/bin/*

set -e

cmake -G Ninja "$SOURCES/llvm-$LLVM_VER/llvm" \
-DCMAKE_C_COMPILER=$CC \
-DCMAKE_CXX_COMPILER=$CXX \
-DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
-DLLVM_TABLEGEN=$BUILD/tblgen/bin/llvm-tblgen \
-DCLANG_TABLEGEN=$BUILD/tblgen/bin/clang-tblgen \
-DLLVM_NATIVE_TOOL_DIR=$BUILD/tblgen/bin \
-DLLVM_USE_HOST_TOOLS=OFF \
-DLLVM_VERSION_SUFFIX="" \
-DLLVM_APPEND_VC_REV=OFF \
-DLLVM_ENABLE_PROJECTS="llvm;lld;clang" \
-DLLVM_ENABLE_LLD=ON \
-DLLVM_TARGETS_TO_BUILD="X86;AArch64;RISCV" \
-DLLVM_INSTALL_BINUTILS_SYMLINKS=ON \
-DLLVM_INSTALL_CCTOOLS_SYMLINKS=ON \
-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
-DLLVM_INCLUDE_EXAMPLES=OFF \
-DLLVM_ENABLE_PIC=ON \
-DLLVM_ENABLE_LTO=OFF \
-DLLVM_INCLUDE_GO_TESTS=OFF \
-DLLVM_INCLUDE_TESTS=OFF \
-DLLVM_HOST_TRIPLE=$TARGET \
-DLLVM_DEFAULT_TARGET_TRIPLE=$TARGET \
-DLLVM_ENABLE_LIBXML2=OFF \
-DLLVM_ENABLE_ZLIB=ON\
-DLLVM_ENABLE_BACKTRACES=OFF \
-DLLVM_BUILD_LLVM_DYLIB=ON \
-DLLVM_LINK_LLVM_DYLIB=ON \
-DLLVM_OPTIMIZED_TABLEGEN=OFF \
-DLLVM_INCLUDE_BENCHMARKS=OFF \
-DLLVM_INCLUDE_DOCS=ON \
-DLLVM_TOOL_LLVM_ITANIUM_DEMANGLE_FUZZER_BUILD=OFF \
-DLLVM_TOOL_LLVM_MC_ASSEMBLE_FUZZER_BUILD=OFF \
-DLLVM_TOOL_LLVM_MC_DISASSEMBLE_FUZZER_BUILD=OFF \
-DLLVM_TOOL_LLVM_OPT_FUZZER_BUILD=OFF \
-DLLVM_TOOL_LLVM_MICROSOFT_DEMANGLE_FUZZER_BUILD=OFF \
-DLLVM_TOOL_LLVM_GO_BUILD=OFF \
-DLLVM_INSTALL_UTILS=ON \
-DLLVM_ENABLE_LIBCXX=ON \
-DLLVM_STATIC_LINK_CXX_STDLIB=ON \
-DLLVM_ENABLE_LIBEDIT=OFF \
-DLLVM_ENABLE_TERMINFO=OFF \
-DLIBCXX_ENABLE_FILESYSTEM=ON \
-DLIBCXX_USE_COMPILER_RT=ON \
-DLIBCXX_HAS_MUSL_LIBC=ON \
-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
-DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=ON \
-DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON \
-DLIBCXX_INSTALL_LIBRARY=ON \
-DLIBCXXABI_ENABLE_ASSERTIONS=ON \
-DLIBCXXABI_USE_COMPILER_RT=ON \
-DLIBCXXABI_USE_LLVM_UNWINDER=ON \
-DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
-DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=YES \
-DLIBCXXABI_ENABLE_SHARED=OFF \
-DLIBCXXABI_ENABLE_STATIC=ON \
-DLIBCXXABI_INSTALL_LIBRARY=ON \
-DLIBUNWIND_ENABLE_SHARED=ON \
-DLIBUNWIND_ENABLE_STATIC=ON \
-DLIBUNWIND_INSTALL_LIBRARY=ON \
-DLIBUNWIND_USE_COMPILER_RT=ON \
-DCLANG_DEFAULT_LINKER=lld \
-DCLANG_DEFAULT_CXX_STDLIB='libc++' \
-DCLANG_DEFAULT_RTLIB=compiler-rt \
-DCLANG_DEFAULT_UNWINDLIB=libunwind \
-DCLANG_VENDOR="Iglunix" \
-DCLANG_ENABLE_STATIC_ANALYZER=OFF \
-DCLANG_ENABLE_ARCMT=OFF \
-DCLANG_LINK_CLANG_DYLIB=OFF \
-DCLANG_TOOLING_BUILD_AST_INTROSPECTION=OFF \
-DCOMPILER_RT_USE_BUILTINS_LIBRARY=OFF \
-DCOMPILER_RT_DEFAULT_TARGET_ONLY=OFF \
-DCOMPILER_RT_INCLUDE_TESTS=OFF \
-DCOMPILER_RT_BUILD_SANITIZERS=OFF \
-DCOMPILER_RT_BUILD_XRAY=OFF \
-DCOMPILER_RT_BUILD_MEMPROF=OFF \
-DCOMPILER_RT_INCLUDE_TESTS=OFF \
-DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
-DENABLE_EXPERIMENTAL_NEW_PASS_MANAGER=TRUE \
-DCMAKE_SYSROOT=$SYSROOT \
-DCMAKE_C_COMPILER_WORKS=ON \
-DCMAKE_CXX_COMPILER_WORKS=ON \
-DCMAKE_SYSTEM_NAME=Linux \
-DLLVM_CONFIG_PATH=/usr/bin/llvm-config \
-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
-DHAVE_CXX_ATOMICS_WITHOUT_LIB=ON \
-DHAVE_CXX_ATOMICS64_WITHOUT_LIB=ON \
-DHAVE_BACKTRACE=OFF

samu -j$THREADS

DESTDIR=$SYSROOT samu install

ln -s clang $SYSROOT/usr/bin/cc
ln -s clang $SYSROOT/usr/bin/c89
ln -s clang $SYSROOT/usr/bin/c99
ln -s clang++ $SYSROOT/usr/bin/c++
ln -s ld.lld $SYSROOT/usr/bin/ld

touch $REPO_ROOT/.llvm
