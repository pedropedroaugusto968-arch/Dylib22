TWEAK_NAME = SpaceXitV4
SpaceXitV4_FILES = Tweak.xm
SpaceXitV4_CFLAGS = -fobjc-arc -O3
SpaceXitV4_LDFLAGS = -static-libobjc

# FORÇA APENAS 64 BITS (Isso tira o erro do print)
export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0
export THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
