/// 人脸识别配置
class FaceConfig {
  /// 最小人脸阈值
  late int minFaceSize;

  /// 非人脸阈值	0.6	0~1.0
  late double notFace;

  /// 图片爆光度	宽松：30、正常：40、严格：60	0-255
  late double brightness;

  /// 图像模糊阈值	宽松：0.8、正常：0.6、严格：0.4	0~1.0
  late double blurness;

  /// 人脸遮挡阀值	宽松：0.95、正常：0.8、严格：0.4	0~1.0
  late double occlusion;

  /// 低头抬头角度	宽松：30、正常：20、严格：15	0~45
  late int headPitch;

  /// 左右摇头角度	宽松：18、正常：18、严格：15	0~45
  late int headYaw;

  /// 偏头角度	宽松：30、正常：20、严格：15	0~45
  late int headRoll;

  /// 裁剪图片大小
  late int cropFace;

  /// 活体动作
  late Set<LivenessType> livenessTypes;

  /// 动作活体随机
  late bool livenessRandom;

  /// 开启提示音
  late bool sund;

  FaceConfig(
      {this.minFaceSize = 200,
      this.notFace = 0.6,
      this.brightness = 40,
      this.blurness = 0.6,
      this.occlusion = 0.8,
      this.headPitch = 20,
      this.headYaw = 18,
      this.headRoll = 20,
      this.cropFace = 400,
      this.sund = true,
      this.livenessRandom = true,
      Set<LivenessType>? livenessTypes})
      : assert(0.1 <= notFace && notFace <= 1.0),
        assert(0 <= brightness && brightness <= 255),
        assert(0 <= blurness && blurness <= 1.0),
        assert(0 <= occlusion && occlusion <= 1.0),
        assert(0 <= headPitch && headPitch <= 45),
        assert(0 <= headYaw && headYaw <= 45),
        assert(0 <= headRoll && headRoll <= 45),
        assert(0 < cropFace),
        assert(livenessTypes == null || livenessTypes.length > 0) {
    this.livenessTypes = livenessTypes ?? {};
  }

  Map<String, dynamic> toMap() => {
        'minFaceSize': this.minFaceSize,
        'notFace': this.notFace,
        'brightness': this.brightness,
        'blurness': this.blurness,
        'occlusion': this.occlusion,
        'headPitch': this.headPitch,
        'headYaw': this.headYaw,
        'headRoll': this.headRoll,
        'cropFace': this.cropFace,
        'sund': this.sund,
        'livenessTypes': this.livenessTypes.map((v) => v.code).toList(),
        'livenessRandom': livenessRandom,
      };
}

/// 活体动作
class LivenessType {
  final String code;

  const LivenessType._(this.code);

  /// 眨眼
  static const Eye = LivenessType._('Eye');

  /// 张嘴
  static const Mouth = LivenessType._('Mouth');

  /// 向左转头
  static const HeadLeft = LivenessType._('HeadLeft');

  /// 向右转头
  static const HeadRight = LivenessType._('HeadRight');

  /// 向上抬头
  static const HeadUp = LivenessType._('HeadUp');

  /// 向下低头
  static const HeadDown = LivenessType._('HeadDown');

  /// 所有动作
  static const all = [Eye, Mouth, HeadLeft, HeadRight, HeadUp, HeadDown];
}

/// 采集结果
class CollectResult {
  CollectResult({
    this.imageBase64 = '',
    this.error = '',
  });

  factory CollectResult.fromMap(Map<String, dynamic> map) {
    CollectResult result = CollectResult(
        imageBase64: map['imageBase64'] as String? ?? '',
        error: map['error'] as String? ?? '');
    if (result.imageBase64.isNotEmpty) {
      final RegExp _reg = RegExp('\\s*|\t|\r|\n');
      result.imageBase64 = result.imageBase64.replaceAll(_reg, "").trim();
    }
    return result;
  }

  /// 图片Base64字符串
  late String imageBase64;
  late String error;
}
