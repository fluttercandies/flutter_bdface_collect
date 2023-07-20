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
    private static final int COLLECT_REQ_CODE = 19491001; /// I love China
    public static final int COLLECT_OK_CODE = 10011949; /// I love China
    private static final String channelName = "com.fluttercandies.bdface_collect";
    private Result result;
    static String imageCropBase64, imageSrcBase64;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), channelName);
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
            case MethodConstants.UnInit:
                unInit(result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        result = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener((requestCode, resultCode, data) -> {
            if (requestCode == COLLECT_REQ_CODE) {
                if (this.result != null) {
                    HashMap<String, String> res = null;
                    if (resultCode == COLLECT_OK_CODE) {
                        res = new HashMap<>();
                        res.put("imageCropBase64", imageCropBase64);
                        res.put("imageSrcBase64", imageSrcBase64);
                    }
                    result.success(res);
                }
                imageCropBase64 = imageSrcBase64 = null;
                result = null;
            }
            return false;
        });
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
        result = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        result = null;
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        result = null;
    }

    /// 项目初始化
    private void init(Object arguments, final Result result) {
        String licenseId = (String) arguments;
        String licenseFileName = "idl-license.face-android";
        assert licenseId != null;
        IInitCallback iInitCallback = new IInitCallback() {
            @Override
            public void initSuccess() {
                activity.runOnUiThread(() -> result.success(null));
            }

            @Override
            public void initFailure(int i, String s) {
                activity.runOnUiThread(() -> result.success("errCode: " + i + ", errMsg: " + s));
            }
        };
        FaceSDKManager.getInstance().initialize(activity, licenseId, licenseFileName, iInitCallback);
    }

    /// 采集
    private void collect(Object arguments, final Result result) {
        @SuppressWarnings("unchecked")
        HashMap<String, Object> argumentsMap = (HashMap<String, Object>) arguments;
        int livenessTypeSize = setFaceConfig(argumentsMap);
        Intent intent;
        if (livenessTypeSize == 0) {
            intent = new Intent(activity, FaceDetectActivity.class);
        } else {
            intent = new Intent(activity, FaceLivenessActivity.class);
        }
        activity.startActivityForResult(intent, COLLECT_REQ_CODE);
        this.result = result;
    }

    /// SDK 释放
    private void unInit(final Result result) {
        FaceSDKManager.getInstance().release();
        result.success(null);
    }

    /// 设置配置
    private int setFaceConfig(HashMap<String, Object> argumentsMap) {
        Integer minFaceSize = (Integer) argumentsMap.get("minFaceSize");
        Double notFace = (Double) argumentsMap.get("notFace");
        Double brightness = (Double) argumentsMap.get("brightness");
        Double brightnessMax = (Double) argumentsMap.get("brightnessMax");
        Double blurness = (Double) argumentsMap.get("blurness");
        Double occlusionLeftEye = (Double) argumentsMap.get("occlusionLeftEye");
        Double occlusionRightEye = (Double) argumentsMap.get("occlusionRightEye");
        Double occlusionNose = (Double) argumentsMap.get("occlusionNose");
        Double occlusionMouth = (Double) argumentsMap.get("occlusionMouth");
        Double occlusionLeftContour = (Double) argumentsMap.get("occlusionLeftContour");
        Double occlusionRightContour = (Double) argumentsMap.get("occlusionRightContour");
        Double occlusionChin = (Double) argumentsMap.get("occlusionChin");
        Integer headPitch = (Integer) argumentsMap.get("headPitch");
        Integer headYaw = (Integer) argumentsMap.get("headYaw");
        Integer headRoll = (Integer) argumentsMap.get("headRoll");
        Double eyeClosed = (Double) argumentsMap.get("eyeClosed");
//        Integer cacheImageNum = (Integer) argumentsMap.get("cacheImageNum");
        Double scale = (Double) argumentsMap.get("scale");
        Integer cropHeight = (Integer) argumentsMap.get("cropHeight");
        Integer cropWidth = (Integer) argumentsMap.get("cropWidth");
        Double enlargeRatio = (Double) argumentsMap.get("enlargeRatio");
        Double faceFarRatio = (Double) argumentsMap.get("faceFarRatio");
        Double faceClosedRatio = (Double) argumentsMap.get("faceClosedRatio");
        Integer secType = (Integer) argumentsMap.get("secType");
        @SuppressWarnings("unchecked")
        List<String> livenessTypes = (List<String>) argumentsMap.get("livenessTypes");
        Boolean livenessRandom = (Boolean) argumentsMap.get("livenessRandom");
        Boolean sound = (Boolean) argumentsMap.get("sound");
        assert minFaceSize != null && notFace != null && brightness != null;
        assert brightnessMax != null && blurness != null && occlusionLeftEye != null;
        assert occlusionRightEye != null && occlusionChin != null;
//        assert occlusionRightEye != null && occlusionChin != null && cacheImageNum != null;
        assert occlusionNose != null && occlusionMouth != null && eyeClosed != null && sound != null;
        assert occlusionLeftContour != null && occlusionRightContour != null && secType != null;
        assert headPitch != null && headYaw != null && headRoll != null;
        assert scale != null && cropHeight != null && cropWidth != null;
        assert enlargeRatio != null && faceFarRatio != null && faceClosedRatio != null;
        assert livenessTypes != null && livenessRandom != null;

        FaceConfig config = FaceSDKManager.getInstance().getFaceConfig();
        // 设置 最小人脸阈值
        config.setMinFaceSize(minFaceSize);
        // 设置 非人脸阈值
        config.setNotFaceValue(notFace.floatValue());
        // 设置 图片最小光照阈值
        config.setBrightnessValue(brightness.floatValue());
        // 设置 图片最大光照阈值
        config.setBrightnessMaxValue(brightnessMax.floatValue());
        // 设置 图像模糊阈值
        config.setBlurnessValue(blurness.floatValue());
        // 设置 左眼遮挡阀值
        config.setOcclusionLeftEyeValue(occlusionLeftEye.floatValue());
        // 设置 右眼遮挡阀值
        config.setOcclusionRightEyeValue(occlusionRightEye.floatValue());
        // 设置 鼻子遮挡阀值
        config.setOcclusionNoseValue(occlusionNose.floatValue());
        // 设置 嘴巴遮挡阀值
        config.setOcclusionMouthValue(occlusionMouth.floatValue());
        // 设置 左脸颊遮挡阀值
        config.setOcclusionLeftContourValue(occlusionLeftContour.floatValue());
        // 设置 右脸颊遮挡阀值
        config.setOcclusionRightContourValue(occlusionRightContour.floatValue());
        // 设置 下巴遮挡阀值
        config.setOcclusionChinValue(occlusionChin.floatValue());
        // 设置 低头抬头角度
        config.setHeadPitchValue(headPitch);
        // 设置 左右摇头角度
        config.setHeadYawValue(headYaw);
        // 设置 偏头角度
        config.setHeadRollValue(headRoll);
        // 设置 闭眼阈值
        config.setEyeClosedValue(eyeClosed.floatValue());
        // 设置 图片缓存数量
        config.setCacheImageNum(3);
//        config.setCacheImageNum(cacheImageNum);
        // 设置 原图缩放系数
        config.setScale(scale.floatValue());
        // 设置 抠图宽高的设定，为了保证好的抠图效果，建议高宽比是4：3
        config.setCropHeight(cropHeight);
        config.setCropWidth(cropWidth);
        // 设置 抠图人脸框与背景比例
        config.setEnlargeRatio(enlargeRatio.floatValue());
        // 设置 检测框远近比率
        config.setFaceFarRatio(faceFarRatio.floatValue());
        config.setFaceClosedRatio(faceClosedRatio.floatValue());
        // 设置 加密类型，0：Base64加密，上传时image_sec传false；1：百度加密文件加密，上传时image_sec传true
        config.setSecType(secType);
        // 设置 开启提示音
        config.setSound(sound);
        // 检测超时设置
        config.setTimeDetectModule(FaceEnvironment.TIME_DETECT_MODULE);
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
        return livenessTypeEnums.size();
    }
}
