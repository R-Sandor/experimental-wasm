#include "hello_imgui/hello_imgui.h"
#include "hello_imgui/hello_imgui_widgets.h"
#include "imgui.h"
#include <cmath>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

int main(int, char *[]) {

#ifdef ASSETS_LOCATION
  HelloImGui::SetAssetsFolder(ASSETS_LOCATION);
#endif

  auto guiFunction = [&]() {
    static char url[256] = {0};
    ImGui::SetCursorPos(ImVec2(19.5, 10.5));
    ImGui::Text("url");
    ImGui::SetCursorPos(ImVec2(52, 9.5));
    ImGui::InputTextWithHint("##", "https://findfirst.dev", url,
                             IM_ARRAYSIZE(url));
    ImGui::ShowDemoWindow();
  };
  constexpr HelloImGui::ScreenSize DefaultWindowSize = {1000, 1000};

  HelloImGui::Run(guiFunction, "FindFirst Desktop", false, true,
                  DefaultWindowSize);

  return 0;
}
