import 'dart:async';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'model.dart';

class FlutterBdfaceCollect extends _ServiceApi {
  FlutterBdfaceCollect._();

  static FlutterBdfaceCollect instance = FlutterBdfaceCollect._();
}

class _ServiceApi {
  static const String _ChannelName = 'com.fluttercandies.bdface_collect';
  final MethodChannel _methodChannel = MethodChannel(_ChannelName);

  Future<String?> get platformVersion async {
    final String? version = await _methodChannel
        .invokeMethod<String>(MethodConstants.GetPlatformVersion);
    return version;
  }

  /// 初始化
  Future<String?> init(String licenseId) async {
    // var s = await Permission.camera.status;
    // if (![PermissionStatus.granted, PermissionStatus.limited].contains(s)) {
    //   s = await Permission.camera.request();
    //   if (![PermissionStatus.granted, PermissionStatus.limited].contains(s)) {
    //     return "errCode: OTHER_ERROR, errMsg: 无相机使用权限";
    //   }
    // }
    // if (Platform.isAndroid) {
    //   s = await Permission.storage.status;
    //   if (![PermissionStatus.granted, PermissionStatus.limited].contains(s)) {
    //     s = await Permission.storage.request();
    //     if (![PermissionStatus.granted, PermissionStatus.limited].contains(s)) {
    //       return "errCode: OTHER_ERROR, errMsg: 无本地存储权限";
    //     }
    //   }
    // }
    final String? err = await _methodChannel.invokeMethod<String>(
        MethodConstants.Init, licenseId);
    return err;
  }

  /// 采集
  Future<CollectResult> collect(FaceConfig config) async {
    final Map<String, dynamic>? result = await _methodChannel.invokeMapMethod(
        MethodConstants.Collect, config.toMap());
    if (result == null) {
      return CollectResult(error: "取消识别");
    }
    return CollectResult.fromMap(result);
  }

  /// 释放
  Future<void> unInit() async {
    await _methodChannel.invokeMethod(MethodConstants.UnInit);
  }
}
