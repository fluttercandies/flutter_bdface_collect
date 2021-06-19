# flutter_bdface_collect

a baidu face offline collect plugin. Only Android and IOS platforms are supported. 【armeabi-v7a、arm64-v8a、x86】

百度人脸离线采集插件，只支持安卓和iOS。【armeabi-v7a、arm64-v8a、x86】

## SDK Version
| Platform | Version |
|   ----   |   ----  |
|  Android |   3.2.1 |
|   iOS    |    3.1  |

## Preparing for use
### Android
在 Android 项目的`app/src/main/assets` 目录下放入百度离线采集SDK的Android授权文件，文件名固定为 `idl-license.face-android`
SDK 会校验 apk 签名，请使用申请授权相符的签名证书
### iOS
由于使用了[permission_handler](https://pub.dev/packages/permission_handler) 
校验隐私授权，请按照permission_handler的使用文档添加使用相机的权限声明。

在 `Info.plist` 的 `dict` 标签内添加以下内容
```xml
<key>NSCameraUsageDescription</key>
<string>使用相机</string>
```
在 iOS 项目的 `Runner` 目前下放入百度离线采集SDK的iOS授权文件，文件名固定为 `idl-license.face-ios`，并将文件加入资源
![example](https://raw.githubusercontent.com/fluttercandies/flutter_bdface_collect/main/doc/QQ20210616-175934.jpg)

## Usage

### Init 初始化
```dart 
    late var licenseId;
    if (Platform.isAndroid) licenseId = "demo-face-android";
    else if (Platform.isIOS) licenseId = "demo-face-ios";
    print('开始初始化');
    String? err = await FlutterBdfaceCollect.instance.init(licenseId);
    print('初始化结果${err == null ? '成功' : '失败'}');
```

### Collect 采集
```dart
    FaceConfig config = FaceConfig(livenessTypes: Set.from(LivenessType.all.sublist(1, 4)));
    CollectRresult res = await FlutterBdfaceCollect.instance.collect(config);
    print('采集错误结果:${res.error.isNotEmpty} 内容：${res.error}');
    print('采集图片imageBase64:${res.imageBase64.isNotEmpty}');
```
### UnInit 释放
```dart
    FlutterBdfaceCollect.instance.unInit();
```








