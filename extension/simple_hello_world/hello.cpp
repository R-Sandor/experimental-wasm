// hello.cpp - WASM module for Chrome extension
#include <emscripten/bind.h>
#include <string>
#include <sstream>

class HTMLGenerator {
public:
    std::string getHelloHTML() {
        return "<h1>Hello from C++ WASM!</h1><p>This HTML was generated in C++</p>";
    }

    std::string createGreeting(const std::string& name) {
        std::ostringstream html;
        html << "<div style='padding:20px;background:#f0f0f0;border-radius:8px;'>"
             << "<h2>Hello, " << name << "!</h2>"
             << "<p>This greeting was created by C++ and compiled to WebAssembly.</p>"
             << "</div>";
        return html.str();
    }

    std::string createButton(const std::string& text) {
        return "<button style='padding:10px 20px;background:#007bff;color:white;"
               "border:none;border-radius:4px;cursor:pointer;'>" + text + "</button>";
    }
};

// Bind C++ class to JavaScript
EMSCRIPTEN_BINDINGS(hello_module) {
    emscripten::class_<HTMLGenerator>("HTMLGenerator")
        .constructor<>()
        .function("getHelloHTML", &HTMLGenerator::getHelloHTML)
        .function("createGreeting", &HTMLGenerator::createGreeting)
        .function("createButton", &HTMLGenerator::createButton);
}
