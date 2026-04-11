# include(./host.profile)
[settings]
os=Emscripten
arch=wasm
compiler=clang
compiler.version=17
build_type=Release

# [tool_requires]
# emsdk/3.1.73

[conf]
tools.cmake.cmaketoolchain:system_name=Emscripten
tools.build:defines=["EMSCRIPTEN"]
tools.cmake.cmaketoolchain:user_toolchain=["$ENV{EMSDK}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake"]

[buildenv]
CMAKE_C_COMPILER=emcc
CMAKE_CXX_COMPILER=em++
EMCC_FORCE_STDLIBS=1
EMCC_CFLAGS=-sUSE_PTHREADS=0
EMCC_CXXFLAGS=-sUSE_PTHREADS=0
