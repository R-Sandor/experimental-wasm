.PHONY: conan_default conan_wasm configure_wasm build_wasm wasm

default: 
	$(MAKE) conan_default

conan_default:
	conan install . --profile:build=default --build=missing

conan_wasm:
	conan install . --profile:build=default --profile:host=conan-profiles/emscripten.profile --build=missing

wasm: 
	$(MAKE) configure_wasm
	$(MAKE)	build_wasm

configure_wasm:
	type cmake
	which cmake
	# Prevent any emscripten conflicts
	$(SHELL) -c "cmake --preset=conan-release"

build_wasm: 
	$(SHELL) -c "cmake --build --preset=conan-release"
