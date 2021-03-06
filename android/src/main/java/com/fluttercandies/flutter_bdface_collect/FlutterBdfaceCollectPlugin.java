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

    /// ???????????????
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

    /// ??????
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

    /// SDK ??????
    private void unInit(final Result result) {
        FaceSDKManager.getInstance().release();
        result.success(null);
    }

    /// ????????????
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
        Integer cacheImageNum = (Integer) argumentsMap.get("cacheImageNum");
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
        Boolean sund = (Boolean) argumentsMap.get("sund");
        assert minFaceSize != null && notFace != null && brightness != null;
        assert brightnessMax != null && blurness != null && occlusionLeftEye != null;
        assert occlusionRightEye != null && occlusionChin != null && cacheImageNum != null;
        assert occlusionNose != null && occlusionMouth != null && eyeClosed != null && sund != null;
        assert occlusionLeftContour != null && occlusionRightContour != null && secType != null;
        assert headPitch != null && headYaw != null && headRoll != null;
        assert scale != null && cropHeight != null && cropWidth != null;
        assert enlargeRatio != null && faceFarRatio != null && faceClosedRatio != null;
        assert livenessTypes != null && livenessRandom != null;

        FaceConfig config = FaceSDKManager.getInstance().getFaceConfig();
        // ?????? ??????????????????
        config.setMinFaceSize(minFaceSize);
        // ?????? ???????????????
        config.setNotFaceValue(notFace.floatValue());
        // ?????? ????????????????????????
        config.setBrightnessValue(brightness.floatValue());
        // ?????? ????????????????????????
        config.setBrightnessMaxValue(brightnessMax.floatValue());
        // ?????? ??????????????????
        config.setBlurnessValue(blurness.floatValue());
        // ?????? ??????????????????
        config.setOcclusionLeftEyeValue(occlusionLeftEye.floatValue());
        // ?????? ??????????????????
        config.setOcclusionRightEyeValue(occlusionRightEye.floatValue());
        // ?????? ??????????????????
        config.setOcclusionNoseValue(occlusionNose.floatValue());
        // ?????? ??????????????????
        config.setOcclusionMouthValue(occlusionMouth.floatValue());
        // ?????? ?????????????????????
        config.setOcclusionLeftContourValue(occlusionLeftContour.floatValue());
        // ?????? ?????????????????????
        config.setOcclusionRightContourValue(occlusionRightContour.floatValue());
        // ?????? ??????????????????
        config.setOcclusionChinValue(occlusionChin.floatValue());
        // ?????? ??????????????????
        config.setHeadPitchValue(headPitch);
        // ?????? ??????????????????
        config.setHeadYawValue(headYaw);
        // ?????? ????????????
        config.setHeadRollValue(headRoll);
        // ?????? ????????????
        config.setEyeClosedValue(eyeClosed.floatValue());
        // ?????? ??????????????????
        config.setCacheImageNum(cacheImageNum);
        // ?????? ??????????????????
        config.setScale(scale.floatValue());
        // ?????? ???????????????????????????????????????????????????????????????????????????4???3
        config.setCropHeight(cropHeight);
        config.setCropWidth(cropWidth);
        // ?????? ??????????????????????????????
        config.setEnlargeRatio(enlargeRatio.floatValue());
        // ?????? ?????????????????????
        config.setFaceFarRatio(faceFarRatio.floatValue());
        config.setFaceClosedRatio(faceClosedRatio.floatValue());
        // ?????? ???????????????0???Base64??????????????????image_sec???false???1???????????????????????????????????????image_sec???true
        config.setSecType(secType);
        // ?????? ???????????????
        config.setSound(sund);
        // ??????????????????
        config.setTimeDetectModule(FaceEnvironment.TIME_DETECT_MODULE);
        // ?????? ????????????????????????
        config.setLivenessRandom(livenessRandom);
        // ?????? ????????????
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
