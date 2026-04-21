TWEAK_NAME = AntiCrashSpace
AntiCrashSpace_FILES = Tweak.xm
AntiCrashSpace_CFLAGS = -fobjc-arc -O2

export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0
export THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
