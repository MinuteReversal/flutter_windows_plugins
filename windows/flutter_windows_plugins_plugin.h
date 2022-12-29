#ifndef FLUTTER_PLUGIN_FLUTTER_WINDOWS_PLUGINS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_WINDOWS_PLUGINS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_windows_plugins {
  typedef struct ImageResult
  {
    int width = 0;
    int height = 0;
    uint8_t* buffer = nullptr;
  }ImageResult;

  class FlutterWindowsPluginsPlugin : public flutter::Plugin {
  public:
    uint8_t buffer[256 * 256 * 4];
    FlutterDesktopPixelBuffer flutter_pixel_buffer;
    flutter::TextureVariant* texture;

    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

    FlutterWindowsPluginsPlugin(flutter::TextureRegistrar* textures);

    virtual ~FlutterWindowsPluginsPlugin();

    void OpenImageFile(uint8_t* result);

    void BrushColor(uint8_t* data);

    void CreateColorImage(uint8_t* buffer, std::string color, int width, int height);

    // Disallow copy and assign.
    FlutterWindowsPluginsPlugin(const FlutterWindowsPluginsPlugin&) = delete;
    FlutterWindowsPluginsPlugin& operator=(const FlutterWindowsPluginsPlugin&) = delete;

  private:
    flutter::TextureRegistrar* texture_registara_;

    int64_t texture_id = 0;

    // Called when a method is called on this plugin's channel from Dart.
    void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  };

}  // namespace flutter_windows_plugins

#endif  // FLUTTER_PLUGIN_FLUTTER_WINDOWS_PLUGINS_PLUGIN_H_
