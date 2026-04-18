DEBUG = 0
FINALPACKAGE = 1
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SpaceXit
SpaceXit_FILES = Tweak.xm Menu.mm
# Flags de otimização e ocultação
SpaceXit_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden
SpaceXit_FRAMEWORKS = UIKit QuartzCore CoreGraphics Metal MetalKit

include $(THEOS_MAKE_PATH)/tweak.mk
