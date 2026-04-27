# include(./host.profile)
[settings]
os=Emscripten
arch=wasm
compiler=clang
compiler.version=17
build_type=Release

# toolchain is now provided by tool_requires("emsdk/5.0.3") in conanfile.py

[conf]
tools.cmake.cmaketoolchain:system_name=Emscripten
tools.build:defines=["EMSCRIPTEN"]
# tools.cmake.cmaketoolchain:user_toolchain - NO LONGER NEEDED! emsdk recipe provides this automatically

[buildenv]
# These are also provided by emsdk, but keeping for compatibility
CMAKE_C_COMPILER=emcc
CMAKE_CXX_COMPILER=em++
EMCC_FORCE_STDLIBS=1
EMCC_CFLAGS=-sUSE_PTHREADS=0
EMCC_CXXFLAGS=-sUSE_PTHREADS=0
