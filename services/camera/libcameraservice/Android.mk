# Copyright 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH:= $(call my-dir)

#
# libcameraservice
#

include $(CLEAR_VARS)

# Camera service source

LOCAL_SRC_FILES :=  \
    CameraService.cpp \
    CameraFlashlight.cpp \
    common/Camera2ClientBase.cpp \
    common/CameraDeviceBase.cpp \
    common/CameraProviderManager.cpp \
    common/FrameProcessorBase.cpp \
    api1/CameraClient.cpp \
    api1/Camera2Client.cpp \
    api1/client2/Parameters.cpp \
    api1/client2/FrameProcessor.cpp \
    api1/client2/StreamingProcessor.cpp \
    api1/client2/JpegProcessor.cpp \
    api1/client2/CallbackProcessor.cpp \
    api1/client2/JpegCompressor.cpp \
    api1/client2/CaptureSequencer.cpp \
    api1/client2/ZslProcessor.cpp \
    api2/CameraDeviceClient.cpp \
    device1/CameraHardwareInterface.cpp \
    device3/Camera3Device.cpp \
    device3/Camera3Stream.cpp \
    device3/Camera3IOStreamBase.cpp \
    device3/Camera3InputStream.cpp \
    device3/Camera3OutputStream.cpp \
    device3/Camera3DummyStream.cpp \
    device3/Camera3SharedOutputStream.cpp \
    device3/StatusTracker.cpp \
    device3/Camera3BufferManager.cpp \
    device3/Camera3StreamSplitter.cpp \
    gui/RingBufferConsumer.cpp \
    utils/CameraTraces.cpp \
    utils/AutoConditionLock.cpp \
    utils/TagMonitor.cpp \
    utils/LatencyHistogram.cpp \
#    api1/StreamImgBuf.cpp \
#    api1/Format.cpp \


LOCAL_SHARED_LIBRARIES:= \
    libui \
    liblog \
    libutils \
    libbinder \
    libcutils \
    libmedia \
    libmediautils \
    libcamera_client \
    libcamera_metadata \
    libfmq \
    libgui \
    libhardware \
    libhidlbase \
    libhidltransport \
    libjpeg \
    libmemunreachable \
    android.hardware.camera.common@1.0 \
    android.hardware.camera.provider@2.4 \
    android.hardware.camera.device@1.0 \
    android.hardware.camera.device@3.2 \
    android.hardware.camera.device@3.3 \
#    libcam.client \
#    libcam_utils \


ifeq ($(TARGET_USES_QTI_CAMERA_DEVICE), true)
LOCAL_CFLAGS += -DQTI_CAMERA_DEVICE
LOCAL_SHARED_LIBRARIES += \
    vendor.qti.hardware.camera.device@1.0
endif



LOCAL_EXPORT_SHARED_LIBRARY_HEADERS := libbinder libcamera_client libfmq

LOCAL_C_INCLUDES += \
    system/media/private/camera/include \
    system/media/camera/include \
    frameworks/native/include/media/openmax \
    frameworks/native/libs/nativewindow/include \
    frameworks/native/libs/nativebase/include \
    frameworks/native/libs/arect/include

LOCAL_EXPORT_C_INCLUDE_DIRS := \
    frameworks/av/services/camera/libcameraservice

LOCAL_CFLAGS += -Wall -Wextra -Werror -Wno-unused-parameter


ifneq ($(BOARD_NUMBER_OF_CAMERAS),)
    LOCAL_CFLAGS += -DMAX_CAMERAS=$(BOARD_NUMBER_OF_CAMERAS)
endif

# Enable MTK stuff
ifeq ($(BOARD_USES_MTK_HARDWARE), true)
    LOCAL_CFLAGS += -DMTK_HARDWARE -Wno-c++11-narrowing -Wno-format -Wno-format-extra-args
    LOCAL_CPPFLAGS += -DMTK_HARDWARE -Wno-c++11-narrowing -Wno-format -Wno-format-extra-args
   
    LOCAL_SHARED_LIBRARIES += libdl
    LOCAL_WHOLE_STATIC_LIBRARIES += libcamera_client_mtk
#    #LOCAL_SHARED_LIBRARIES += libcamera_client_mtk

    LOCAL_C_INCLUDES += $(TOP)/frameworks/av/include
    LOCAL_C_INCLUDES += $(TOP)/hardware/include
    LOCAL_C_INCLUDES += $(TOP)/hardware/interfaces/camera/common/1.0/default/include

    LOCAL_SRC_FILES += mediatek/api1/CameraClient.cpp    
    LOCAL_SRC_FILES += mediatek/CameraService.cpp

endif


# Workaround for invalid unused-lambda-capture warning http://b/38349491
LOCAL_CLANG_CFLAGS += -Wno-error=unused-lambda-capture

ifeq ($(TARGET_HAS_LEGACY_CAMERA_HAL1),true)
    LOCAL_CFLAGS += -DNO_CAMERA_SERVER
endif

LOCAL_MODULE:= libcameraservice

include $(BUILD_SHARED_LIBRARY)
