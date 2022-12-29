import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_windows_plugins/flutter_windows_plugins.dart';
import 'package:flutter_windows_plugins/flutter_windows_plugins_platform_interface.dart';
import 'package:flutter_windows_plugins/flutter_windows_plugins_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWindowsPluginsPlatform with MockPlatformInterfaceMixin implements FlutterWindowsPluginsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> fn1() => Future.value();

  @override
  Future<int?> fn2() => Future.value(222);

  @override
  Future<void> fn3(int x) => Future.value();

  @override
  Future<int?> fn4(int x) => Future.value(x);

  @override
  Future<Map<Object?, Object?>?> fn5(Map<Object?, Object?> map) => Future.value({'id': 123, 'name': 'welcome zhy'});

  @override
  Future<List<Object?>?> fn6(List<Object?>? list) => Future.value([7, 8, 9]);

  @override
  Future<Uint8List?> fn7(Uint8List list) => Future.value(Uint8List(8));

  @override
  Future<void> blue() {
    throw UnimplementedError();
  }

  @override
  Future<void> green() {
    throw UnimplementedError();
  }

  @override
  Future<int?> pickfile() {
    throw UnimplementedError();
  }

  @override
  Future<void> red() {
    throw UnimplementedError();
  }

  @override
  Future<int?> texture() {
    throw UnimplementedError();
  }
}

void main() {
  final FlutterWindowsPluginsPlatform initialPlatform = FlutterWindowsPluginsPlatform.instance;

  test('$MethodChannelFlutterWindowsPlugins is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWindowsPlugins>());
  });

  test('getPlatformVersion', () async {
    FlutterWindowsPlugins flutterWindowsPluginsPlugin = FlutterWindowsPlugins();
    MockFlutterWindowsPluginsPlatform fakePlatform = MockFlutterWindowsPluginsPlatform();
    FlutterWindowsPluginsPlatform.instance = fakePlatform;

    expect(await flutterWindowsPluginsPlugin.getPlatformVersion(), '42');
  });
}
