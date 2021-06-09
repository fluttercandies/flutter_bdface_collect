import 'dart:async';

import 'package:flutter/services.dart';

import 'constants.dart';
import 'model.dart';

class FlutterBdfaceCollect extends _ServiceApi {
  FlutterBdfaceCollect._();

  static FlutterBdfaceCollect instance = FlutterBdfaceCollect._();
}

class _ServiceApi {
  final MethodChannel _methodChannel = MethodChannel('flutter_bdface_collect');

  Future<String?> get platformVersion async {
    final String? version = await _methodChannel
        .invokeMethod<String>(MethodConstants.GetPlatformVersion);
    return version;
  }

  /// 初始化
  Future<String?> init(String licenseId) async {
    final String? err = await _methodChannel.invokeMethod<String>(
        MethodConstants.Init, licenseId);
    return err;
  }

  /// 采集人脸
  Future<CollectRresult> collect(FaceConfig config) async {
    final Map<String, dynamic>? result = await _methodChannel
        .invokeMapMethod<String, dynamic>(MethodConstants.Collect);
    if (result == null) {
      print("result 为空");
      return CollectRresult(error: "取消识别");
    }
    return CollectRresult.fromMap(result);
  }
}
