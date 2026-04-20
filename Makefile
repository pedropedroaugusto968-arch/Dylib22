ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SucSoftFFH4X
SucSoftFFH4X_FILES = Tweak.xm
SucSoftFFH4X_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
