/// 人脸识别配置
class FaceConfig {
  /// 最小人脸阈值
  late int minFaceSize;

  /// 非人脸阈值	0.6	0~1.0
  late double notFaceValue;

  /// 图片最小光照阈值	宽松：30、正常：40、严格：60	0-255
  late double brightness;

  /// 图片最大光照阈值	宽松：240、正常：220、严格：200	0-255
  late double brightnessMax;

  /// 图像模糊阈值	宽松：0.8、正常：0.6、严格：0.4	0~1.0
  late double blurness;

  /// 左眼遮挡阀值	宽松：0.95、正常：0.8、严格：0.4	0~1.0
  late double occlusionLeftEye;

  /// 右眼遮挡阀值	宽松：0.95、正常：0.8、严格：0.4	0~1.0
  late double occlusionRightEye;

  /// 鼻子遮挡阀值	宽松：0.95、正常：0.8、严格：0.4	0~1.0
  late double occlusionNose;

  /// 嘴巴遮挡阀值	宽松：0.95、正常：0.8、严格：0.4	0~1.0
  late double occlusionMouth;

  /// 左脸颊遮挡阀值	宽松：0.95、正常：0.8、严格：0.4	0~1.0
  late double occlusionLeftContour;

  /// 右脸颊遮挡阀值	宽松：0.95、正常：0.8、严格：0.4	0~1.0
  late double occlusionRightContour;

  /// 下巴遮挡阀值	宽松：0.95、正常：0.8、严格：0.4	0~1.0
  late double occlusionChin;

  /// 低头抬头角度	宽松：30、正常：20、严格：15	0~45
  late int headPitch;

  /// 左右摇头角度	宽松：18、正常：18、严格：15	0~45
  late int headYaw;

  /// 偏头角度	宽松：30、正常：20、严格：15	0~45
  late int headRoll;

  /// 闭眼阈值	0.7	0~1.0
  late double eyeClosed;

  /// 图片缓存数量	3	建议3~6
  late int cacheImageNum;

  /// 原图缩放系数 0.1~1.0
  late double scale;

  /// 抠图宽高的设定，为了保证好的抠图效果，建议高宽比是4：3
  late int cropHeight, cropWidth;

  /// 抠图人脸框与背景比例
  late double enlargeRatio;

  /// 检测框远近比率
  late double faceFarRatio, faceClosedRatio;

  /// 加密类型，0：Base64加密，上传时image_sec传false；1：百度加密文件加密，上传时image_sec传true
  late int secType;

  /// 活体动作
  late Set<LivenessType> livenessTypes;

  /// 动作活体是否随机
  late bool livenessRandom;

  /// 开启提示音
  late bool sund;

  FaceConfig(
      {this.minFaceSize = 200,
      this.notFaceValue = 0.6,
      this.brightness = 40,
      this.brightnessMax = 220,
      this.blurness = 0.6,
      this.occlusionLeftEye = 0.8,
      this.occlusionRightEye = 0.8,
      this.occlusionNose = 0.8,
      this.occlusionMouth = 0.8,
      this.occlusionLeftContour = 0.8,
      this.occlusionRightContour = 0.8,
      this.occlusionChin = 0.8,
      this.headPitch = 20,
      this.headYaw = 18,
      this.headRoll = 20,
      this.eyeClosed = 0.7,
      this.cacheImageNum = 3,
      this.scale = 1,
      this.cropHeight = 640,
      this.cropWidth = 480,
      this.enlargeRatio = 1.5,
      this.faceFarRatio = 0.4,
      this.faceClosedRatio = 1,
      this.secType = 0,
      this.livenessRandom = true,
      this.sund = true,
      Set<LivenessType>? livenessTypes})
      : assert(0.1 <= notFaceValue && notFaceValue <= 1.0),
        assert(0 <= brightness && brightness <= 255),
        assert(0 <= brightnessMax && brightnessMax <= 255),
        assert(0 <= blurness && blurness <= 1.0),
        assert(0 <= occlusionLeftEye && occlusionLeftEye <= 1.0),
        assert(0 <= occlusionRightEye && occlusionRightEye <= 1.0),
        assert(0 <= occlusionNose && occlusionNose <= 1.0),
        assert(0 <= occlusionMouth && occlusionMouth <= 1.0),
        assert(0 <= occlusionLeftContour && occlusionLeftContour <= 1.0),
        assert(0 <= occlusionRightContour && occlusionRightContour <= 1.0),
        assert(0 <= occlusionChin && occlusionChin <= 1.0),
        assert(0 <= headPitch && headPitch <= 45),
        assert(0 <= headYaw && headYaw <= 45),
        assert(0 <= headRoll && headRoll <= 45),
        assert(0 <= eyeClosed && eyeClosed <= 1.0),
        assert(0 <= scale && scale <= 1.0),
        assert(0 < cropHeight && 0 < cropWidth),
        assert(0 <= faceFarRatio && faceFarRatio <= 1.0),
        assert(0 <= faceClosedRatio && faceClosedRatio <= 1.0),
        assert(secType == 0 || secType == 1),
        assert(livenessTypes == null || livenessTypes.length > 1),
        this.livenessTypes = livenessTypes ?? {};

  Map<String, dynamic> toMap() => {
        'minFaceSize': this.minFaceSize,
        'notFaceValue': this.notFaceValue,
        'brightness': this.brightness,
        'brightnessMax': this.brightnessMax,
        'blurness': this.blurness,
        'occlusionLeftEye': this.occlusionLeftEye,
        'occlusionRightEye': this.occlusionRightEye,
        'occlusionNose': this.occlusionNose,
        'occlusionMouth': this.occlusionMouth,
        'occlusionLeftContour': this.occlusionLeftContour,
        'occlusionRightContour': this.occlusionRightContour,
        'occlusionChin': this.occlusionChin,
        'headPitch': this.headPitch,
        'headYaw': this.headYaw,
        'headRoll': this.headRoll,
        'eyeClosed': this.eyeClosed,
        'cacheImageNum': this.cacheImageNum,
        'scale': this.scale,
        'cropHeight': this.cropHeight,
        'cropWidth': this.cropWidth,
        'enlargeRatio': this.enlargeRatio,
        'faceFarRatio': this.faceFarRatio,
        'faceClosedRatio': this.faceClosedRatio,
        'secType': this.secType,
        'livenessTypes': this.livenessTypes.map((v) => v.code).toList(),
        'livenessRandom': this.livenessRandom,
        'sund': this.sund,
      };
}

/// 活体动作
class LivenessType {
  final String code;

  const LivenessType._(this.code);

  static const Eye = LivenessType._('Eye');
  static const Mouth = LivenessType._('Mouth');
  static const HeadLeft = LivenessType._('HeadLeft');
  static const HeadRight = LivenessType._('HeadRight');
  static const HeadUp = LivenessType._('HeadUp');
  static const HeadDown = LivenessType._('HeadDown');

  static const values = [Eye, Mouth, HeadLeft, HeadRight, HeadUp, HeadDown];
}

/// 采集结果
class CollectRresult {
  late String imageBase;
  late String error;

  CollectRresult({this.imageBase = '', this.error = ''});

  factory CollectRresult.fromMap(Map<String, dynamic> map) => CollectRresult(
      imageBase: map['imageBase'] as String? ?? '',
      error: map['error'] as String? ?? '');
}
