.PHONY: conan_default conan_wasm configure_wasm build_wasm wasm check_tools
CONAN_USER_HOME := $(CURDIR)/.conan


default:
	$(MAKE) conan_default

conan_default:
	$(MAKE) check_tools
	CONAN_USER_HOME=$(CONAN_USER_HOME) conan install . --profile:build=default --build=missing

check_tools:
	@command -v conan >/dev/null 2>&1 || { echo "conan not found; install it"; exit 1; }
	@command -v git >/dev/null 2>&1 || { echo "git not found; install it"; exit 1; }

wasm: 
	$(MAKE) check_tools
	@echo "\e[0;34mConan environment setup: installing dependencies \e[0m"
	$(MAKE) conan_wasm
	@echo "\e[0;34mGenerating CMake dependencies/toolchain\e[0m"
	$(MAKE) configure_wasm
	@echo "\e[0;34mBuilding WASM"
	$(MAKE)	build_wasm

conan_wasm:
	CONAN_USER_HOME=$(CONAN_USER_HOME) conan source
	CONAN_USER_HOME=$(CONAN_USER_HOME) conan install . --profile:build=default --profile:host=conan-profiles/emscripten.profile --build=missing

configure_wasm:
	# Prevent any emscripten conflicts
	$(SHELL) -c "cmake --preset=conan-release"

build_wasm: 
	$(SHELL) -c "cmake --build --preset=conan-release"
