.PHONY: conan_default conan_wasm configure_deps build_app wasm check_tools

NPROCS:=1
OS:=$(shell uname -s)

ifeq ($(OS),Linux)
	NPROCS:=$(shell grep -c ^processor /proc/cpuinfo)
endif
ifeq ($(OS),Darwin) # Assume Mac OS X
	NPROCS:=$(shell system_profiler | awk '/Number Of CPUs/{print $4}{next;}')
endif
ifeq ($(OS),Windows)
	NPROCS:=$(env:NUMBER_OF_PROCESSORS)
endif

default:
	$(MAKE) conan_default

check_tools:
	@command -v conan >/dev/null 2>&1 || { echo "conan not found; install it"; exit 1; }
	@command -v git >/dev/null 2>&1 || { echo "git not found; install it"; exit 1; }

conan_default:
	$(MAKE) check_tools
	@conan profile detect -e 
	@conan install . --profile:build=default --build=missing 
	$(MAKE) configure_deps
	$(MAKE) build_app

mingw:
	$(MAKE) check_tools
	$(MAKE) conan_mingw
	$(MAKE) configure_deps
	$(MAKE) build_app

wasm: 
	$(MAKE) check_tools
	@echo "\e[0;34mConan environment setup: installing dependencies \e[0m"
	$(MAKE) conan_wasm
	@echo "\e[0;34mGenerating CMake dependencies/toolchain\e[0m"
	$(MAKE) configure_deps
	@echo "\e[0;34mBuilding WASM"
	$(MAKE)	build_app

conan_mingw:
	$(MAKE) check_tools
	conan install . --profile:build=default --profile:host=conan-profiles/mingw.profile --build=missing

conan_wasm:
	conan source
	conan install . --profile:build=default --profile:host=conan-profiles/emscripten.profile --build=missing

configure_deps:
	# Prevent any emscripten conflicts
	$(SHELL) -c "cmake --preset=conan-release"

build_app: 
	$(SHELL) -c "cmake --build --preset=conan-release -j $(NPROCS)"
