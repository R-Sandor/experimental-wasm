.PHONY: conan_default conan_wasm configure_wasm build_wasm wasm

default: 
	$(MAKE) conan_default

conan_default:
	conan install . --profile:build=default --build=missing

wasm: 
	@echo "\e[0;34mConan environment setup: installing dependencies \e[0m"
	$(MAKE) conan_wasm
	@echo "\e[0;34mGenerating CMake dependencies/toolchain\e[0m"
	$(MAKE) configure_wasm
	@echo "\e[0;34mBuilding WASM"
	$(MAKE)	build_wasm

conan_wasm:
	conan install . --profile:build=default --profile:host=conan-profiles/emscripten.profile --build=missing

configure_wasm:
	# Prevent any emscripten conflicts
	$(SHELL) -c "cmake --preset=conan-release"

build_wasm: 
	$(SHELL) -c "cmake --build --preset=conan-release"
