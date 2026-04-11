cmake_minimum_required(VERSION 3.28)
project(helloworld_with_helloimgui)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Detect Emscripten
if(CMAKE_SYSTEM_NAME STREQUAL "Emscripten" OR DEFINED EMSCRIPTEN OR "$ENV{EMSCRIPTEN}" STREQUAL "1")
  message(STATUS "Configuring for Emscripten: using emscripten contrib.glfw3 port")

  # Compiler flags
  set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -s DISABLE_EXCEPTION_CATCHING=1")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s DISABLE_EXCEPTION_CATCHING=1")

  # Linker flags: use the contrib port instead of building upstream GLFW
  set(EMSCRIPTEN_LINKER_FLAGS
      "--use-port=contrib.glfw3 -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s NO_EXIT_RUNTIME=0 -s ASSERTIONS=1")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${EMSCRIPTEN_LINKER_FLAGS}")

  add_compile_definitions(__EMSCRIPTEN__)

  set(USE_EMSCRIPTEN_GLFW_PORT ON CACHE BOOL "Use Emscripten contrib.glfw3 port" FORCE)
else()
  set(USE_EMSCRIPTEN_GLFW_PORT OFF CACHE BOOL "Use Emscripten contrib.glfw3 port" FORCE)
endif()

# Build hello_imgui
# =================
if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/external/hello_imgui)
    add_subdirectory(external/hello_imgui EXCLUDE_FROM_ALL)
endif()

if (NOT TARGET hello_imgui)
    message(STATUS "Fetching hello_imgui")
    include(FetchContent)
    FetchContent_Declare(hello_imgui
        GIT_REPOSITORY https://github.com/pthom/hello_imgui.git
        GIT_TAG master
        EXCLUDE_FROM_ALL)
    FetchContent_MakeAvailable(hello_imgui)
endif()

# Override hello_imgui's buggy hello_imgui_bundle_assets_from_folder function
# to properly escape @ symbols in paths
if(CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
    function(hello_imgui_bundle_assets_from_folder app_name assets_folder)
        if (IS_DIRECTORY ${assets_folder})
            # Escape @ symbols in the path for emscripten file_packager (@ is used as src@dst separator)
            string(REPLACE "@" "@@" assets_folder_escaped "${assets_folder}")
            target_link_options(
                ${app_name}
                PRIVATE
                "SHELL:--preload-file ${assets_folder_escaped}@/"
            )
        else()
            message(WARNING "hello_imgui_bundle_assets_from_folder: ignoring missing folder ${assets_folder}")
        endif()

        if (HELLOIMGUI_ADD_APP_WITH_INSTALL)
            hello_imgui_get_real_output_directory(${app_name} real_output_directory)
            install(FILES
                ${real_output_directory}/${app_name}.html
                ${real_output_directory}/${app_name}.data
                ${real_output_directory}/${app_name}.js
                ${real_output_directory}/${app_name}.wasm
                DESTINATION .
            )
        endif()
    endfunction()
endif()

option(EXAMPLE_INTEGRATION_PORTABLE_INSTALL "Install in a portable way" ON)

# Create the app target (hello_imgui_add_app defines the target hello_world_)
hello_imgui_add_app(hello_world_ hello_world.main.cpp)

if(WIN32)
  target_link_options(hello_world_ PRIVATE
    -static-libgcc
    -static-libstdc++
  )
endif()

# Link GLFW (guard and prefer imported target names)
if(USE_EMSCRIPTEN_GLFW_PORT)
  # The Emscripten port supplies symbols at link time; no find_package needed.
  # Nothing to link here beyond normal linker flags already added to CMAKE_EXE_LINKER_FLAGS.
  message(STATUS "Using Emscripten contrib.glfw3 port; skipping find_package(glfw)")
else()
  # Prefer modern imported target first
  find_package(glfw3 REQUIRED CONFIG) # CMakeDeps will generate a config file when using Conan
  if(TARGET glfw::glfw)
    target_link_libraries(hello_world_ PRIVATE glfw::glfw)
  elseif(TARGET glfw)
    target_link_libraries(hello_world_ PRIVATE glfw)
  else()
    # best-effort: try pkg-config / fallback
    message(WARNING "GLFW target not found. Ensure CMakeDeps generated the config and CMAKE_PREFIX_PATH includes Conan generators.")
    target_link_libraries(hello_world_ PRIVATE glfw) # keep attempt; will error if not found
  endif()
endif()

if (NOT EXAMPLE_INTEGRATION_PORTABLE_INSTALL)
    set(HELLOIMGUI_ADD_APP_WITH_INSTALL OFF CACHE BOOL "" FORCE)

    include(GNUInstallDirs)
    install(TARGETS hello_world_ DESTINATION ${CMAKE_INSTALL_BINDIR})
    set(assets_install_dir ${CMAKE_INSTALL_DATADIR}/hello_world_)
    install(DIRECTORY assets DESTINATION ${assets_install_dir})

    file(RELATIVE_PATH assets_relative_to_bin
            "/${CMAKE_INSTALL_BINDIR}"
            "/${assets_install_dir}/assets")
    target_compile_definitions(hello_world_ PRIVATE ASSETS_LOCATION="${assets_relative_to_bin}")
endif()

