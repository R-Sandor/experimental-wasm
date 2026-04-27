from conan import ConanFile
from conan.tools.scm import Git
import os
import subprocess


class HelloImGuiTemplateConan(ConanFile):
    name = "hello_imgui_template"
    version = "0.1"
    settings = "os", "arch", "compiler", "build_type"
    generators = "CMakeDeps", "CMakeToolchain"
    exports_sources = "*"

    def generate(self):
        """Automatically setup conan-toolchains and emsdk recipe for new users"""
        # Only needed for Emscripten builds
        if str(self.settings.get_safe("os")) != "Emscripten":
            return

        toolchains_dir = os.path.join(self.recipe_folder, "conan-toolchains")

        # Clone conan-toolchains if not present
        if not os.path.exists(toolchains_dir):
            self.output.info("Cloning conan-toolchains repository...")
            git = Git(self)
            git.clone(
                url="https://github.com/conan-io/conan-toolchains.git",
                target=toolchains_dir,
                args=["--depth", "1"]
            )

        # Add remote if not already added
        try:
            result = subprocess.run(
                ["conan", "remote", "list"],
                capture_output=True,
                text=True,
                check=True
            )
            if "conan-toolchains" not in result.stdout:
                self.output.info("Adding conan-toolchains remote...")
                subprocess.run(
                    ["conan", "remote", "add", "conan-toolchains", toolchains_dir, "--force"],
                    check=True
                )
        except subprocess.CalledProcessError:
            self.output.warning("Could not add conan-toolchains remote")

        # Check if emsdk recipe is exported, if not export it
        try:
            result = subprocess.run(
                ["conan", "list", "emsdk/5.0.3"],
                capture_output=True,
                text=True
            )
            if "emsdk/5.0.3" not in result.stdout:
                self.output.info("Exporting emsdk recipe...")
                emsdk_recipe = os.path.join(toolchains_dir, "recipes", "emsdk", "all")
                subprocess.run(
                    ["conan", "export", emsdk_recipe, "--version=5.0.3", "--name=emsdk"],
                    check=True,
                    cwd=emsdk_recipe
                )
        except subprocess.CalledProcessError:
            self.output.warning("Could not check/export emsdk recipe")

    # keep cmake_layout behavior
    def layout(self):
        from conan.tools.cmake import cmake_layout

        cmake_layout(self)

    def build_requirements(self):
        # Use emsdk toolchain when building for Emscripten
        if str(self.settings.get_safe("os")) == "Emscripten":
            self.tool_requires("emsdk/5.0.3")

    def requirements(self):
        # default: require glfw unless if its emscripten which has its
        # glfw provided by the emsdk installation process.
        # if not os.getenv("WEBBUILD"):
        #
        if str(self.settings.get_safe("os")) != "Emscripten":
            self.requires("glfw/3.4")
