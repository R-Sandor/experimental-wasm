#!/bin/bash
# Compile C++ to WASM with Embind support
em++ hello.cpp \
  -o hello.js \
  -lembind \
  -s WASM=1 \
  -s MODULARIZE=1 \
  -s EXPORT_ES6=1 \
  -s EXPORT_NAME="createHelloModule" \
  -s ENVIRONMENT='web' \
  -s SINGLE_FILE=0 \
  -s DYNAMIC_EXECUTION=0 \
  --bind \
  -O2

if [ $? -eq 0 ]; then
  echo "✓ Compiled hello.cpp to hello.js and hello.wasm"
  echo "  Load the extension folder in Chrome to test"
else
  echo "✗ Compilation failed"
  exit 1
fi
