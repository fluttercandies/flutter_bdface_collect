package com.fluttercandies.flutter_bdface_collect;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.baidu.idl.face.platform.FaceConfig;
import com.baidu.idl.face.platform.FaceSDKManager;
import com.baidu.idl.face.platform.listener.IInitCallback;

import java.util.HashMap;

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
        @SuppressWarnings("unchecked")
        HashMap<Object, Object> argumentsMap = (HashMap<Object, Object>) arguments;
        String licenseId = (String) argumentsMap.get("licenseId");
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
    }
}
