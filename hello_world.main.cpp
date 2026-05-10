#include "hello_imgui/hello_imgui.h"
#include <cmath>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

int main(int, char *[]) {
  float *my_color{new float[4]{0.0, 1.0, 2.0, 3.0}};

#ifdef ASSETS_LOCATION
  HelloImGui::SetAssetsFolder(ASSETS_LOCATION);
#endif
  auto guiFunction = [my_color]() {
    if (ImGui::BeginMenuBar()) {
      if (ImGui::BeginMenu("File")) {
        if (ImGui::MenuItem("Open..", "Ctrl+O")) { /* Do stuff */
        }
        if (ImGui::MenuItem("Save", "Ctrl+S")) { /* Do stuff */
        }
        if (ImGui::MenuItem("Close", "Ctrl+W")) {
        }
        ImGui::EndMenu();
      }
      ImGui::EndMenuBar();
    }

    // Edit a color stored as 4 floats
    ImGui::ColorEdit4("Color", my_color);

    // Generate samples and plot them
    float samples[100];
    for (int n = 0; n < 100; n++)
      samples[n] = sinf(n * 0.2f + ImGui::GetTime() * 1.5f);
    ImGui::PlotLines("Samples", samples, 100);

    // Display contents in a scrolling region
    ImGui::TextColored(ImVec4(1, 1, 0, 1), "Important Stuff");
    ImGui::BeginChild("Scrolling");
    for (int n = 0; n < 50; n++)
      ImGui::Text("%04d: Some text", n);
    ImGui::EndChild();
  };
  constexpr HelloImGui::ScreenSize DefaultWindowSize = {1600, 1600};

  HelloImGui::Run(guiFunction, "FindFirst Desktop", false, true,
                  DefaultWindowSize);

  delete[] my_color;
  return 0;
}
