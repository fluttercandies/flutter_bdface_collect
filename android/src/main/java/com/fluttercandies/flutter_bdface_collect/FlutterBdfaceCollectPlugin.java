package com.fluttercandies.flutter_bdface_collect;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import com.baidu.idl.face.platform.FaceConfig;
import com.baidu.idl.face.platform.FaceSDKManager;
import com.baidu.idl.face.platform.LivenessTypeEnum;

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
    static String imageBase64;

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
                    HashMap<String, String> res = new HashMap<>();
                    if (resultCode == COLLECT_OK_CODE) {
                        res.put("imageBase64", imageBase64);
                    } else {
                        res.put("error", "采集失败");
                    }
                    result.success(res);
                }
                imageBase64 = null;
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
        FaceSDKManager.getInstance().initialize(activity, licenseId, licenseFileName);
        result.success(null);
    }

    /// SDK 释放
    private void unInit(final Result result) {
        FaceSDKManager.release();
        result.success(null);
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

    /// 设置配置
    private int setFaceConfig(HashMap<String, Object> argumentsMap) {
        Integer minFaceSize = (Integer) argumentsMap.get("minFaceSize");
        Double notFace = (Double) argumentsMap.get("notFace");
        Double brightness = (Double) argumentsMap.get("brightness");
        Double blurness = (Double) argumentsMap.get("blurness");
        Double occlusion = (Double) argumentsMap.get("occlusion");
        Integer headPitch = (Integer) argumentsMap.get("headPitch");
        Integer headYaw = (Integer) argumentsMap.get("headYaw");
        Integer headRoll = (Integer) argumentsMap.get("headRoll");
        Integer cropFace = (Integer) argumentsMap.get("cropFace");
        @SuppressWarnings("unchecked")
        List<String> livenessTypes = (List<String>) argumentsMap.get("livenessTypes");
        Boolean livenessRandom = (Boolean) argumentsMap.get("livenessRandom");
        Boolean sund = (Boolean) argumentsMap.get("sund");
        assert minFaceSize != null && notFace != null && brightness != null;
        assert blurness != null && occlusion != null && sund != null;
        assert headPitch != null && headYaw != null && headRoll != null;
        assert cropFace != null && livenessTypes != null && livenessRandom != null;

        FaceConfig config = FaceSDKManager.getInstance().getFaceConfig();
        // 设置 最小人脸阈值
        config.setMinFaceSize(minFaceSize);
        // 设置 非人脸阈值
        config.setNotFaceValue(notFace.floatValue());
        // 设置 图片爆光度
        config.setBrightnessValue(brightness.floatValue());
        // 设置 图像模糊阈值
        config.setBlurnessValue(blurness.floatValue());
        // 设置 人脸遮挡阀值
        config.setOcclusionValue(occlusion.floatValue());
        // 设置 低头抬头角度
        config.setHeadPitchValue(headPitch);
        // 设置 左右摇头角度
        config.setHeadYawValue(headYaw);
        // 设置 偏头角度
        config.setHeadRollValue(headRoll);
        // 设置 裁剪图片大小
        config.setCropFaceValue(cropFace);
        // 设置 开启提示音
        config.setSound(sund);
        // 设置检测使用线程数
        config.setFaceDecodeNumberOfThreads(2);
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
