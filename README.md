# flutter_bdface_collect

a baidu face offline collect plugin. Only Android and IOS platforms are supported. 【armeabi-v7a、arm64-v8a】

百度人脸离线采集插件，只支持安卓和iOS。【armeabi-v7a、arm64-v8a】

# PS: SDK only support armeabi-v7a、arm64-v8a, if want x86, Please select [old-sdk](https://github.com/fluttercandies/flutter_bdface_collect/tree/old-sdk)
# PS: SDK 只支持 armeabi-v7a、arm64-v8a, 如果想使用 x86, 请选择 [old-sdk](https://github.com/fluttercandies/flutter_bdface_collect/tree/old-sdk)

## SDK Version
| Platform | Version |
|   ----   |--------|
|  Android | 4.1.5  |
|   iOS    | 4.1.5  |

## Preparing for use

PS：已注释隐私授权检查，故使用前请自行检查授权

### Android
在 Android 项目的`app/src/main/assets` 目录下放入百度离线采集SDK的Android授权文件，文件名固定为 `idl-license.face-android`
SDK 会校验 apk 签名，请使用申请授权相符的签名证书
### iOS

在 `Info.plist` 的 `dict` 标签内添加以下内容
```xml
<key>NSCameraUsageDescription</key>
<string>使用相机</string>
```
在 iOS 项目的 `Runner` 目录下放入百度离线采集SDK的iOS授权文件，文件名固定为 `idl-license.face-ios`，并将文件加入资源
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
    print('采集原图imageCropBase64:${res.imageSrcBase64.isNotEmpty}');
    print('采集抠图imageSrcBase64:${res.imageCropBase64.isNotEmpty}');
```
### UnInit 释放
```dart
    FlutterBdfaceCollect.instance.unInit();
```

## 常见问题
### iOS
### Android









