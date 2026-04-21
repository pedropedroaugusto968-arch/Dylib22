TWEAK_NAME = SpaceXitV4
SpaceXitV4_FILES = Tweak.xm
SpaceXitV4_CFLAGS = -fobjc-arc -O3
SpaceXitV4_LDFLAGS = -static-libobjc

# Isso remove as pastas extras que denunciam o hack
export THEOS_PACKAGE_SCHEME = rootless
include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
