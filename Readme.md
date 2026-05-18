# Web GUIs in C++?

The words C++ web GUI likely draw loathing memory of building applications of yesterday.
Historically building any GUI application in C++ has been tedious task ladened with
complications.

- (_OLD SCHOOL_) **CGI**; html tag printing, that still requires
  CSS/JS to make it visually appealing and has vulnerabilities of responding
  to web request from an native executable.
- (_Newer WEB ONLY_) **Wt Webtoolkit**; ; a fair option but few examples of production
  applications, licensing concerns for commercialization.
- (_Enterprise_) **Qt**: Desktop focused with WASM; licensing concerns if
  application becomes commercial, some web support for WASM but the executables
  are large.
- (_Open Source_) **IM_GUI** BARE BONES; Open source, WASM ready or adaptable
  requires writing EVERYTHING FROM SCRATCH...

However, there is a new option:

- (_Portable, Open Source_) **hello_imgui** open source, portable and
  cross environment ready; one source code that runs everywhere, native desktop
  and browser and potentially in browser extensions and comes with widgets/examples.

Disclaimer This is still an on going experiment and if one is reading this than the author (me), has
most likely directed you here.

## TOC

<!---- TODO: FINISH TOC !--->

- [ ] [Installing](#installing)

## Installing

<!---- TODO: Installing!--->

The simplest way to get started is run `make build`.
Project dependencies are mostly managed by Conan.

External dependencies like Emscripten are handled with `conan source`,
which downloads the Emscripten SDK for the user.

This is preferred to requiring contributors to all have the same version
and ensure the Emscripten environment is sourced before building.

Make build does a tool check for conan, and git. There is bound to be
potentially be other requirements or missing tools across environments.
Just report them and update this list or open a issue for it to be included here.

### General System Dependencies

- Compiler: GCC/G++, Clang
- Git

## Running the extension

Currently the extension requires wasm build the easiest way is `make wasm`
The output will be in `build/Release`.

1. Copy the FindFirstApp.js to ./extension/
2. Copy the FindFirstApp.data to ./extension/
3. Copy the FindFirstApp.wasm to ./extension/
4. Load the `extension/` directory in chrome extensions -> `load unpacked`.
