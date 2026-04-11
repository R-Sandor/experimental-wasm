from conan import ConanFile
import os


class HelloImGuiTemplateConan(ConanFile):
    name = "hello_imgui_template"
    version = "0.1"
    settings = "os", "arch", "compiler", "build_type"
    generators = "CMakeDeps", "CMakeToolchain"
    exports_sources = "*"

    # keep cmake_layout behavior
    def layout(self):
        from conan.tools.cmake import cmake_layout

        cmake_layout(self)

    def requirements(self):
        # default: require glfw unless if its emscripten which has its
        # glfw provided by the emsdk installation process.
        # if not os.getenv("WEBBUILD"):
        #
        if str(self.settings.get_safe("os")) != "Emscripten":
            self.requires("glfw/3.4")
