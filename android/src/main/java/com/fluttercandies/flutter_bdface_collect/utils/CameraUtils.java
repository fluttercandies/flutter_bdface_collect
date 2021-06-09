/**
 * Copyright (C) 2017 Baidu Inc. All rights reserved.
 */
package com.fluttercandies.flutter_bdface_collect.utils;

import android.hardware.Camera;

/**
 * CameraUtils
 */
public class CameraUtils {

    public static final String TAG = CameraUtils.class.getSimpleName();

    public static void releaseCamera(Camera camera) {
        try {
            camera.release();
        } catch (RuntimeException e2) {
            e2.printStackTrace();
        } catch (Exception e1) {
            e1.printStackTrace();
        } finally {
        }
    }
}
