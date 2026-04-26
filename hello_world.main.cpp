#include "hello_imgui/hello_imgui.h"

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

int main(int , char *[])
{
#ifdef ASSETS_LOCATION
    HelloImGui::SetAssetsFolder(ASSETS_LOCATION);
#endif
    auto guiFunction = []() {
        ImGui::Text("Hello, ");                    // Display a simple label
        HelloImGui::ImageFromAsset("world.jpg");   // Display a static image
        if (ImGui::Button("Bye!")) {               // Display a button
            // For web/extension builds, close the window
#ifdef __EMSCRIPTEN__
            EM_ASM({
                window.close();
            });
#else
            // For desktop builds, exit the app
            HelloImGui::GetRunnerParams()->appShallExit = true;
#endif
        }
     };
    HelloImGui::Run(guiFunction, "Hello, globe", true);
    return 0;
}
