import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bdface_collect/flutter_bdface_collect.dart';
import 'package:flutter_bdface_collect/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    late String licenseId;
    if (Platform.isAndroid) {
      licenseId = 'bdfacecollectexample-face-android';
    } else if (Platform.isIOS) {
      licenseId = 'bdfacecollectexample-face-ios';
    }
    var err = await FlutterBdfaceCollect.instance.init(licenseId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: TextButton(
            child: Text("初始化"),
            onPressed: () {
              var livenessTypeList = LivenessType.all;
              var config = FaceConfig(livenessTypes: Set.from(livenessTypeList));
              FlutterBdfaceCollect.instance.collect(config);
            },
          ),
        ),
      ),
    );
  }
}
