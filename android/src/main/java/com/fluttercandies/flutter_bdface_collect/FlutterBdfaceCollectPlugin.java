package com.fluttercandies.flutter_bdface_collect;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.baidu.idl.face.platform.FaceConfig;
import com.baidu.idl.face.platform.FaceEnvironment;
import com.baidu.idl.face.platform.FaceSDKManager;
import com.baidu.idl.face.platform.LivenessTypeEnum;
import com.baidu.idl.face.platform.listener.IInitCallback;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterBdfaceCollectPlugin
 */
public class FlutterBdfaceCollectPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.fluttercandies.bdface_collect");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        switch (call.method) {
            case MethodConstants.GetPlatformVersion:
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case MethodConstants.Init:
                init(call.arguments, result);
                break;
            case MethodConstants.Collect:
                collect(call.arguments, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {
    }

    /// 项目初始化
    private void init(Object arguments, final Result result) {
        String licenseId = (String) arguments;
        String licenseFileName = "idl-license.face-android";
        assert licenseId != null;
        IInitCallback iInitCallback = new IInitCallback() {
            @Override
            public void initSuccess() {
                result.success(null);
            }

            @Override
            public void initFailure(int i, String s) {
                result.success("errCode: " + i + ", errMsg: " + s);
            }
        };
        FaceSDKManager.getInstance().initialize(activity, licenseId, licenseFileName, iInitCallback);
    }

    /// 采集！
    private void collect(Object arguments, final Result result) {
        FaceConfig config = FaceSDKManager.getInstance().getFaceConfig();
        @SuppressWarnings("unchecked")
        HashMap<Object, Object> argumentsMap = (HashMap<Object, Object>) arguments;
        Integer minFaceSize = (Integer) argumentsMap.get("minFaceSize");
        Float notFaceValue = (Float) argumentsMap.get("notFaceValue");
        Float brightnessValue = (Float) argumentsMap.get("brightnessValue");
        Float brightnessMaxValue = (Float) argumentsMap.get("brightnessMaxValue");
        Float blurnessValue = (Float) argumentsMap.get("blurnessValue");
        Float occlusionLeftEyeValue = (Float) argumentsMap.get("occlusionLeftEyeValue");
        Float occlusionRightEyeValue = (Float) argumentsMap.get("occlusionRightEyeValue");
        Float occlusionNoseValue = (Float) argumentsMap.get("occlusionNoseValue");
        Float occlusionMouthValue = (Float) argumentsMap.get("occlusionMouthValue");
        Float occlusionLeftContourValue = (Float) argumentsMap.get("occlusionLeftContourValue");
        Float occlusionRightContourValue = (Float) argumentsMap.get("occlusionRightContourValue");
        Float occlusionChinValue = (Float) argumentsMap.get("occlusionChinValue");
        Integer headPitchValue = (Integer) argumentsMap.get("headPitchValue");
        Integer headYawValue = (Integer) argumentsMap.get("headYawValue");
        Integer headRollValue = (Integer) argumentsMap.get("headRollValue");
        Float eyeClosedValue = (Float) argumentsMap.get("eyeClosedValue");
        Integer cacheImageNum = (Integer) argumentsMap.get("cacheImageNum");
        Float scale = (Float) argumentsMap.get("scale");
        Integer cropHeight = (Integer) argumentsMap.get("cropHeight");
        Integer cropWidth = (Integer) argumentsMap.get("cropWidth");
        Float enlargeRatio = (Float) argumentsMap.get("enlargeRatio");
        Float faceFarRatio = (Float) argumentsMap.get("faceFarRatio");
        Float faceClosedRatio = (Float) argumentsMap.get("faceClosedRatio");
        Integer secType = (Integer) argumentsMap.get("secType");
        @SuppressWarnings("unchecked")
        List<String> livenessTypes = (List<String>) argumentsMap.get("livenessTypes");
        Boolean livenessRandom = (Boolean) argumentsMap.get("livenessRandom");
        Boolean sund = (Boolean) argumentsMap.get("sund");
        assert minFaceSize != null && notFaceValue != null && brightnessValue != null;
        assert brightnessMaxValue != null && blurnessValue != null && occlusionLeftEyeValue != null;
        assert occlusionRightEyeValue != null && occlusionChinValue != null && cacheImageNum != null;
        assert occlusionNoseValue != null && occlusionMouthValue != null && eyeClosedValue != null;
        assert occlusionLeftContourValue != null && occlusionRightContourValue != null;
        assert headPitchValue != null && headYawValue != null && headRollValue != null;
        assert scale != null && cropHeight != null && cropWidth != null;
        assert enlargeRatio != null && faceFarRatio != null && faceClosedRatio != null;
        assert livenessTypes != null && secType != null && livenessRandom != null && sund != null;

        // 设置 最小人脸阈值
        config.setMinFaceSize(minFaceSize);
        // 设置 非人脸阈值
        config.setNotFaceValue(notFaceValue);
        // 设置 图片最小光照阈值
        config.setBlurnessValue(brightnessValue);
        // 设置 图片最大光照阈值
        config.setBrightnessMaxValue(brightnessMaxValue);
        // 设置 图像模糊阈值
        config.setBlurnessValue(blurnessValue);
        // 设置 左眼遮挡阀值
        config.setOcclusionLeftEyeValue(occlusionLeftEyeValue);
        // 设置 右眼遮挡阀值
        config.setOcclusionRightEyeValue(occlusionRightEyeValue);
        // 设置 鼻子遮挡阀值
        config.setOcclusionNoseValue(occlusionNoseValue);
        // 设置 嘴巴遮挡阀值
        config.setOcclusionMouthValue(occlusionMouthValue);
        // 设置 左脸颊遮挡阀值
        config.setOcclusionLeftContourValue(occlusionLeftContourValue);
        // 设置 右脸颊遮挡阀值
        config.setOcclusionRightContourValue(occlusionRightContourValue);
        // 设置 下巴遮挡阀值
        config.setOcclusionChinValue(occlusionChinValue);
        // 设置 低头抬头角度
        config.setHeadPitchValue(headPitchValue);
        // 设置 左右摇头角度
        config.setHeadYawValue(headYawValue);
        // 设置 偏头角度
        config.setHeadRollValue(headRollValue);
        // 设置 闭眼阈值
        config.setEyeClosedValue(eyeClosedValue);
        // 设置 图片缓存数量
        config.setCacheImageNum(cacheImageNum);
        // 设置 原图缩放系数
        config.setScale(scale);
        // 设置 抠图宽高的设定，为了保证好的抠图效果，建议高宽比是4：3
        config.setCropHeight(cropHeight);
        config.setCropWidth(cropWidth);
        // 设置 抠图人脸框与背景比例
        config.setEnlargeRatio(enlargeRatio);
        // 设置 检测框远近比率
        config.setEnlargeRatio(faceFarRatio);
        config.setEnlargeRatio(faceClosedRatio);
        // 设置 加密类型，0：Base64加密，上传时image_sec传false；1：百度加密文件加密，上传时image_sec传true
        config.setSecType(secType);
        // 设置 开启提示音
        config.setSound(sund);
        // 设置 动作活体是否随机
        config.setLivenessRandom(livenessRandom);
        // 设置 活体动作
        List<LivenessTypeEnum> livenessTypeEnums = new ArrayList<>();
        for (String type : livenessTypes) {
            switch (type) {
                case "Eye":
                    livenessTypeEnums.add(LivenessTypeEnum.Eye);
                    break;
                case "Mouth":
                    livenessTypeEnums.add(LivenessTypeEnum.Mouth);
                    break;
                case "HeadLeft":
                    livenessTypeEnums.add(LivenessTypeEnum.HeadLeft);
                    break;
                case "HeadRight":
                    livenessTypeEnums.add(LivenessTypeEnum.HeadRight);
                    break;
                case "HeadUp":
                    livenessTypeEnums.add(LivenessTypeEnum.HeadUp);
                    break;
                case "HeadDown":
                    livenessTypeEnums.add(LivenessTypeEnum.HeadDown);
                    break;
            }
        }
        config.setLivenessTypeList(livenessTypeEnums);
        FaceSDKManager.getInstance().setFaceConfig(config);

        Intent intent;
        if (livenessTypeEnums.isEmpty()) {
            intent = new Intent(activity, FaceLivenessActivity.class);
        } else {
            intent = new Intent(activity, FaceDetectActivity.class);
        }
        activity.startActivity(intent);
        result.success(null);

    }
}
