import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_windows_plugins_platform_interface.dart';

/// An implementation of [FlutterWindowsPluginsPlatform] that uses method channels.
class MethodChannelFlutterWindowsPlugins extends FlutterWindowsPluginsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_windows_plugins');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> fn1() async {
    await methodChannel.invokeMethod<void>('fn1');
  }

  @override
  Future<int?> fn2() async {
    return await methodChannel.invokeMethod<int>('fn2');
  }

  @override
  Future<void> fn3(int x) async {
    await methodChannel.invokeMethod<void>('fn3', x);
  }

  @override
  Future<int?> fn4(int x) async {
    return await methodChannel.invokeMethod<int>('fn4', x);
  }

  @override
  Future<Map<Object?, Object?>?> fn5(Map<Object?, Object?> map) async {
    return await methodChannel.invokeMethod<Map<Object?, Object?>>('fn5', map);
  }

  @override
  Future<List<Object?>?> fn6(List<Object?>? list) async {
    return await methodChannel.invokeMethod<List<Object?>?>('fn6', list);
  }

  @override
  Future<int?> texture() async {
    return await methodChannel.invokeMethod<int>('texture');
  }

  @override
  Future<void> red() async {
    return await methodChannel.invokeMethod<void>('red');
  }

  @override
  Future<void> green() async {
    return await methodChannel.invokeMethod<void>('green');
  }

  @override
  Future<void> blue() async {
    return await methodChannel.invokeMethod<void>('blue');
  }

  @override
  Future<int?> pickfile() async {
    return await methodChannel.invokeMethod<int>('pickfile');
  }
}
