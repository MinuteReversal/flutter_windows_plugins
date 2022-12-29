import 'flutter_windows_plugins_platform_interface.dart';

class FlutterWindowsPlugins {
  Future<String?> getPlatformVersion() {
    return FlutterWindowsPluginsPlatform.instance.getPlatformVersion();
  }

  Future<void> fn1() {
    return FlutterWindowsPluginsPlatform.instance.fn1();
  }

  Future<int?> fn2() {
    return FlutterWindowsPluginsPlatform.instance.fn2();
  }

  Future<void> fn3(int x) {
    return FlutterWindowsPluginsPlatform.instance.fn3(x);
  }

  Future<int?> fn4(int x) {
    return FlutterWindowsPluginsPlatform.instance.fn4(x);
  }

  Future<Map<Object?, Object?>?> fn5(Map<Object?, Object?> map) {
    return FlutterWindowsPluginsPlatform.instance.fn5(map);
  }

  Future<List<Object?>?> fn6(List<Object?>? list) {
    return FlutterWindowsPluginsPlatform.instance.fn6(list);
  }

  Future<int?> texture() {
    return FlutterWindowsPluginsPlatform.instance.texture();
  }

  Future<void> red() {
    return FlutterWindowsPluginsPlatform.instance.red();
  }

  Future<void> green() {
    return FlutterWindowsPluginsPlatform.instance.green();
  }

  Future<void> blue() {
    return FlutterWindowsPluginsPlatform.instance.blue();
  }

  Future<int?> pickfile() {
    return FlutterWindowsPluginsPlatform.instance.pickfile();
  }
}
