TWEAK_NAME = SucSoftFFH4X

# Compila o menu de abas com otimização máxima
SucSoftFFH4X_FILES = Tweak.xm
SucSoftFFH4X_CFLAGS = -fobjc-arc -O3
SucSoftFFH4X_FRAMEWORKS = UIKit QuartzCore CoreGraphics Foundation

# Suporte para todos os iPhones modernos
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
