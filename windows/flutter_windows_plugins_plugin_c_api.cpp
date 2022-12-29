#include "include/flutter_windows_plugins/flutter_windows_plugins_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_windows_plugins_plugin.h"

void FlutterWindowsPluginsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_windows_plugins::FlutterWindowsPluginsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
