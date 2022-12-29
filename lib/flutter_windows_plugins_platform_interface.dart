import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_windows_plugins_method_channel.dart';
import 'dart:typed_data';

abstract class FlutterWindowsPluginsPlatform extends PlatformInterface {
  /// Constructs a FlutterWindowsPluginsPlatform.
  FlutterWindowsPluginsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWindowsPluginsPlatform _instance =
      MethodChannelFlutterWindowsPlugins();

  /// The default instance of [FlutterWindowsPluginsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWindowsPlugins].
  static FlutterWindowsPluginsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWindowsPluginsPlatform] when
  /// they register themselves.
  static set instance(FlutterWindowsPluginsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> fn1() {
    throw UnimplementedError('fn1() has not been implemented.');
  }

  Future<int?> fn2() {
    throw UnimplementedError('fn2() has not been implemented.');
  }

  Future<void> fn3(int x) {
    throw UnimplementedError('fn3() has not been implemented.');
  }

  Future<int?> fn4(int x) {
    throw UnimplementedError('fn4() has not been implemented.');
  }

  Future<Map<Object?, Object?>?> fn5(Map<Object?, Object?> map) {
    throw UnimplementedError('fn5() has not been implemented.');
  }

  Future<List<Object?>?> fn6(List<Object?>? list) {
    throw UnimplementedError('fn6() has not been implemented.');
  }

  Future<Uint8List?> fn7(Uint8List list) {
    throw UnimplementedError('fn7() has not been implemented.');
  }

  Future<int?> texture() {
    throw UnimplementedError('fn7() has not been implemented.');
  }

  Future<void> red() {
    throw UnimplementedError('red() has not been implemented.');
  }

  Future<void> green() {
    throw UnimplementedError('green() has not been implemented.');
  }

  Future<void> blue() {
    throw UnimplementedError('blue() has not been implemented.');
  }

  Future<int?> pickfile() {
    throw UnimplementedError('blue() has not been implemented.');
  }
}
