import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bdface_collect/flutter_bdface_collect.dart';
import 'package:flutter_bdface_collect/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '人脸识别测试',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("人脸识别测试")),
      body: Center(
        child: imageBytes == null
            ? const Text('未开始初始化')
            : Image.memory(imageBytes!),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: _faceCollect,
        child: const Icon(Icons.face),
      ),
    );
  }

  Future<void> _faceCollect() async {
    late String licenseId;
    if (Platform.isAndroid) {
      licenseId = 'flutter_bdface_collect_example-face-android';
    } else if (Platform.isIOS) {
      licenseId = 'flutter_bdface_collect_example-face-ios';
    }
    var err = await FlutterBdfaceCollect.instance.init(licenseId);
    if (err != null) print('百度人脸采集初始化失败:$err');
    var livenessTypeList = LivenessType.all.sublist(3);
    var config = FaceConfig(livenessTypes: Set.from(livenessTypeList));
    CollectResult res = await FlutterBdfaceCollect.instance.collect(config);
    print(
        "百度人脸采集结果：error:${res.error} imageSrcBase64 isEmpty:${res.imageSrcBase64.isEmpty}");
    if (res.imageSrcBase64.isEmpty) return setState(() => imageBytes = null);
    setState(() => imageBytes = base64Decode(res.imageSrcBase64));
  }
}
