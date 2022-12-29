import 'dart:ffi';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_windows_plugins/flutter_windows_plugins.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  int textureId = -1;
  final _flutterWindowsPluginsPlugin = FlutterWindowsPlugins();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterWindowsPluginsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: onFn1,
                child: const Text('fn1'),
              ),
              ElevatedButton(
                onPressed: onFn2,
                child: const Text('fn2'),
              ),
              ElevatedButton(
                onPressed: onFn3,
                child: const Text('fn3'),
              ),
              ElevatedButton(
                onPressed: onFn4,
                child: const Text('fn4'),
              ),
              ElevatedButton(
                onPressed: onFn5,
                child: const Text("fn5"),
              ),
              ElevatedButton(
                onPressed: onFn6,
                child: const Text("fn6"),
              ),
              ElevatedButton(
                onPressed: onTexture,
                child: const Text("texture"),
              ),
              Text('$textureId'),
              SizedBox(
                width: 256,
                height: 256,
                child: Texture(textureId: textureId),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onRed,
                    child: const Text('red'),
                  ),
                  ElevatedButton(
                    onPressed: onGreen,
                    child: const Text('green'),
                  ),
                  ElevatedButton(
                    onPressed: onBlue,
                    child: const Text('blue'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onPickFile,
                child: const Text("pick file"),
              ),
              ElevatedButton(onPressed: onFFiFn1, child: const Text("ffi fn1")),
              ElevatedButton(onPressed: onFFiFn2, child: const Text("ffi fn2")),
              ElevatedButton(onPressed: onFFiFn3, child: const Text("ffi fn3")),
              ElevatedButton(onPressed: onFFiFn4, child: const Text("ffi fn4")),
            ],
          ),
        ),
      ),
    );
  }

  void onFFiFn4() {
    const libraryPath = "dll_main.dll"; //~/example/dll_main.dll
    final dylib = DynamicLibrary.open(libraryPath);
    final int Function(int) fn4 = dylib.lookup<NativeFunction<Int32 Function(Int32)>>('fn4').asFunction();
    final result = fn4(4);
    log(result.toString());
  }

  void onFFiFn3() {
    const libraryPath = "dll_main.dll"; //~/example/dll_main.dll
    final dylib = DynamicLibrary.open(libraryPath);
    final int Function() fn3 = dylib.lookup<NativeFunction<Int32 Function()>>('fn3').asFunction();
    final result = fn3();
    log(result.toString());
  }

  void onFFiFn2() {
    const libraryPath = "dll_main.dll"; //~/example/dll_main.dll
    final dylib = DynamicLibrary.open(libraryPath);
    final void Function(int) fn2 = dylib.lookup<NativeFunction<Void Function(Int32)>>('fn2').asFunction();
    fn2(2);
  }

  void onFFiFn1() {
    const libraryPath = "dll_main.dll"; //~/example/dll_main.dll
    final dylib = DynamicLibrary.open(libraryPath);
    final void Function() fn1 = dylib.lookup<NativeFunction<Void Function()>>('fn1').asFunction();
    fn1();
  }

  void onPickFile() async {
    final result = await _flutterWindowsPluginsPlugin.pickfile();
    if (result is int) {
      setState(() {
        textureId = result;
      });
    }
  }

  void onBlue() async {
    await _flutterWindowsPluginsPlugin.blue();
  }

  void onGreen() async {
    await _flutterWindowsPluginsPlugin.green();
  }

  void onRed() async {
    await _flutterWindowsPluginsPlugin.red();
  }

  void onTexture() async {
    final result = await _flutterWindowsPluginsPlugin.texture();
    if (result is int) {
      setState(() {
        textureId = result;
      });
    }
  }

  void onFn6() async {
    final result = await _flutterWindowsPluginsPlugin.fn6([1, 2, 3, 4, 5]);
    if (result != null) {
      log(result.join(','));
    }
  }

  void onFn5() async {
    final result = await _flutterWindowsPluginsPlugin.fn5({"id": 123, "name": "zhy"});
    if (result != null) {
      log('id:${result['id']},name:${result["name"]}');
    }
  }

  void onFn4() async {
    final result = await _flutterWindowsPluginsPlugin.fn4(444);
    log(result.toString());
  }

  void onFn3() async {
    await _flutterWindowsPluginsPlugin.fn3(333);
  }

  void onFn2() async {
    final result = await _flutterWindowsPluginsPlugin.fn2();
    log(result.toString());
  }

  void onFn1() async {
    await _flutterWindowsPluginsPlugin.fn1();
  }
}
