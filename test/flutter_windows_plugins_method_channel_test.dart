import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_windows_plugins/flutter_windows_plugins_method_channel.dart';

void main() {
  MethodChannelFlutterWindowsPlugins platform = MethodChannelFlutterWindowsPlugins();
  const MethodChannel channel = MethodChannel('flutter_windows_plugins');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
