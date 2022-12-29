#include "flutter_windows_plugins_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>
#include <thread>

namespace flutter_windows_plugins {

  void setTimeout(std::function<void(void)> func, int milliseconds) {
    std::thread([=]() {
      std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
      func();
      }).detach();
  }

  void FlutterWindowsPluginsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
    auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        registrar->messenger(), "flutter_windows_plugins",
        &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<FlutterWindowsPluginsPlugin>(registrar->texture_registrar());

    channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

    registrar->AddPlugin(std::move(plugin));
  }

  FlutterWindowsPluginsPlugin::FlutterWindowsPluginsPlugin(flutter::TextureRegistrar* textures) :texture_registara_(textures) {
    std::cout << "constructor" << std::endl;
    flutter_pixel_buffer = FlutterDesktopPixelBuffer();
    memset(&flutter_pixel_buffer, 0, sizeof(flutter_pixel_buffer));
    texture = new flutter::TextureVariant(flutter::PixelBufferTexture([=](size_t width, size_t height) ->const FlutterDesktopPixelBuffer* {
      return &flutter_pixel_buffer;
      }));
    texture_id = texture_registara_->RegisterTexture(texture);
  }

  FlutterWindowsPluginsPlugin::~FlutterWindowsPluginsPlugin() {
    delete texture;
    texture = nullptr;
  }

  void FlutterWindowsPluginsPlugin::OpenImageFile(uint8_t* data) {
    const int width = 256;
    const int height = 256;
    HINSTANCE hInst = GetModuleHandle(NULL);
    HWND hWnd = GetActiveWindow();
    wchar_t szPath[MAX_PATH] = {};
    OPENFILENAME ofn = {
      sizeof(ofn) }; // common dialog box structure
    ofn.hwndOwner = hWnd;
    ofn.lpstrFilter = L"*.bmp\0";
    ofn.lpstrFile = szPath;
    ofn.nMaxFile = ARRAYSIZE(szPath);

    BOOL fOk = GetOpenFileName(&ofn);
    if (!fOk) return;

    HBITMAP hBitmap = (HBITMAP)LoadImage(
      hInst, szPath, IMAGE_BITMAP, width,
      height, LR_LOADFROMFILE);//load image


    BYTE* lpPixels = new BYTE[width * height * 4];//b,g,r,reserved
    GetBitmapBits(hBitmap, width * height * 4, lpPixels);

    for (size_t y = 0; y < height; y++)
    {
      for (size_t x = 0; x < width; x++) {
        size_t index = x + y * width;
        data[index * 4 + 0] = lpPixels[index * 4 + 2];
        data[index * 4 + 1] = lpPixels[index * 4 + 1];
        data[index * 4 + 2] = lpPixels[index * 4 + 0];
        data[index * 4 + 3] = 255;
      }
    }

    DeleteObject(hBitmap);
    delete[] lpPixels;
  }

  void FlutterWindowsPluginsPlugin::BrushColor(uint8_t* data) {
    const int width = 256;
    const int height = 256;
    HWND hWnd = GetActiveWindow();
    HDC hdcWindow = GetDC(hWnd);
    HDC hdcMemDC = CreateCompatibleDC(hdcWindow);
    HBITMAP hBitmap =
      CreateCompatibleBitmap(hdcWindow, width, height);
    SelectObject(hdcMemDC, hBitmap);

    RECT rc = { 0, 0, 20, 20 };
    HBRUSH brush = CreateSolidBrush(0x0000FF);
    FillRect(hdcMemDC, &rc, brush);

    BYTE* lpPixels = new BYTE[256 * 256 * 4];//b,g,r,reserved
    GetBitmapBits(hBitmap, width * height * 4, lpPixels);

    for (size_t y = 0; y < height; y++)
    {
      for (size_t x = 0; x < width; x++) {
        size_t index = x + y * width;
        data[index * 4 + 0] = lpPixels[index * 4 + 2];
        data[index * 4 + 1] = lpPixels[index * 4 + 1];
        data[index * 4 + 2] = lpPixels[index * 4 + 0];
        data[index * 4 + 3] = 255;
      }
    }

    DeleteObject(hBitmap);
    ReleaseDC(hWnd, hdcWindow);
    ReleaseDC(hWnd, hdcMemDC);
    delete[] lpPixels;
  }

  void FlutterWindowsPluginsPlugin::CreateColorImage(uint8_t* data, std::string color = "", const int width = 256, const int height = 256) {
    std::cout << color << std::endl;
    /// |0|1|2|3|4|5|6|7|
    /// |r|g|b|a|r|g|b|a|
    for (size_t y = 0; y < height; y++) {
      for (size_t x = 0; x < width; x++)
      {
        auto index = x + y * width;
        *(data + index * 4 + 0) = color.compare("red") == 0 ? 255 : 0;//red
        *(data + index * 4 + 1) = color.compare("green") == 0 ? 255 : 0;//green
        *(data + index * 4 + 2) = color.compare("blue") == 0 ? 255 : 0;//blue
        *(data + index * 4 + 3) = 255;// alpha
      }
    }
  }

  void FlutterWindowsPluginsPlugin::HandleMethodCall(
    //https://github.com/flutter/plugins/blob/main/packages/url_launcher/url_launcher_windows/windows/url_launcher_plugin.cpp
    const flutter::MethodCall<>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    std::string methodName = method_call.method_name();

    if (methodName.compare("getPlatformVersion") == 0) {
      std::ostringstream version_stream;
      version_stream << "Windows ";
      if (IsWindows10OrGreater()) {
        version_stream << "10+";
      }
      else if (IsWindows8OrGreater()) {
        version_stream << "8";
      }
      else if (IsWindows7OrGreater()) {
        version_stream << "7";
      }
      result->Success(flutter::EncodableValue(version_stream.str()));
    }
    else if (methodName.compare("fn1") == 0) {
      std::cout << "C++ fn1 call" << std::endl;
      result->Success();
    }
    else if (methodName.compare("fn2") == 0) {
      std::cout << "C++ fn2 call" << std::endl;
      result->Success(flutter::EncodableValue(222));
    }
    else if (methodName.compare("fn3") == 0) {
      const auto* arguments = std::get_if<int>(method_call.arguments());
      std::cout << "C++ fn3 call " << *arguments << std::endl;
      result->Success();
    }
    else if (methodName.compare("fn4") == 0) {
      const auto* arguments = std::get_if<int>(method_call.arguments());
      std::cout << "C++ fn4 call " << *arguments << std::endl;
      result->Success(flutter::EncodableValue(*arguments));
    }
    else if (methodName.compare("fn5") == 0) {
      //input
      const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
      const int id = std::get<int>(arguments->find(flutter::EncodableValue("id"))->second);
      const std::string name = std::get<std::string>(arguments->find(flutter::EncodableValue("name"))->second);
      std::cout << "C++ fn5 call id:" << id << ",name:" << name << std::endl;

      //output
      flutter::EncodableMap map;
      map[flutter::EncodableValue("id")] = id + 1;
      map[flutter::EncodableValue("name")] = "welcome " + name;
      result->Success(map);
    }
    else if (methodName.compare("fn6") == 0) {
      const auto* arguments = std::get_if<flutter::EncodableList>(method_call.arguments());
      std::string text;

      for (auto it = arguments->begin(); it != arguments->end(); it++) {
        text = text + std::to_string(std::get<int>(*it)) + ",";
      }

      std::cout << "C++ fn6 call [" << text << "]" << std::endl;

      flutter::EncodableList list;
      list.push_back(flutter::EncodableValue(6));
      list.push_back(flutter::EncodableValue(7));
      list.push_back(flutter::EncodableValue(8));
      list.push_back(flutter::EncodableValue(9));
      result->Success(list);
    }
    else if (methodName.compare("pickfile") == 0) {
      OpenImageFile(buffer);
      flutter_pixel_buffer.width = 256;
      flutter_pixel_buffer.height = 256;
      flutter_pixel_buffer.buffer = buffer;
      texture_registara_->MarkTextureFrameAvailable(texture_id);
      result->Success(flutter::EncodableValue(texture_id));
    }
    //https://github.com/flutter/plugins/blob/main/packages/video_player/video_player_android/android/src/main/java/io/flutter/plugins/videoplayer/VideoPlayerPlugin.java
    //https://juejin.cn/post/6866815272636907527
    //https://juejin.cn/post/7060399423913721863
    //https://blog.csdn.net/u013113678/article/details/125492286
    //https://github.com/jnschulze/flutter-playground/blob/master/windows_texture_test/windows/windows_texture_test_plugin.cpp
    else if (methodName.compare("texture") == 0) {

      CreateColorImage(buffer);
      flutter_pixel_buffer.width = 256;
      flutter_pixel_buffer.height = 256;
      flutter_pixel_buffer.buffer = buffer;

      texture_registara_->MarkTextureFrameAvailable(texture_id);

      setTimeout([&] {
        CreateColorImage(buffer, "red");
        texture_registara_->MarkTextureFrameAvailable(texture_id);
        }, 1000);

      setTimeout([=] {
        CreateColorImage(buffer, "green");
        texture_registara_->MarkTextureFrameAvailable(texture_id);
        }, 2000);

      setTimeout([this] {
        CreateColorImage(buffer, "blue");
        texture_registara_->MarkTextureFrameAvailable(texture_id);
        }, 3000);

      std::cout << "run here" << std::endl;
      result->Success(flutter::EncodableValue(texture_id));
    }
    else if (methodName.compare("red") == 0) {
      CreateColorImage(buffer, "red");
      texture_registara_->MarkTextureFrameAvailable(texture_id);
      result->Success();
    }
    else if (methodName.compare("green") == 0) {
      CreateColorImage(buffer, "green");
      texture_registara_->MarkTextureFrameAvailable(texture_id);
      result->Success();
    }
    else if (methodName.compare("blue") == 0) {
      CreateColorImage(buffer, "blue");
      texture_registara_->MarkTextureFrameAvailable(texture_id);
      result->Success();
    }
    else {
      result->NotImplemented();
    }
  }

} // namespace flutter_windows_plugins