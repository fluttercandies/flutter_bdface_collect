import 'dart:async';

import 'package:flutter/services.dart';

import 'constants.dart';

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
  Future<String?> init(String licenseId, String licenseFileName) async {
    final String? err = await _methodChannel.invokeMethod(MethodConstants.Init);
    return err;
  }
}
