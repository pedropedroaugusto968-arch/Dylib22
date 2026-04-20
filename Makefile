# Nome do projeto
TWEAK_NAME = SucSoftFFH4X

# Arquivos que serão compilados
SucSoftFFH4X_FILES = Tweak.xm
SucSoftFFH4X_CFLAGS = -fobjc-arc -O3 # -O3 garante o máximo de performance/sem lag

# Frameworks necessários para o Menu e Mod Streamer
SucSoftFFH4X_FRAMEWORKS = UIKit QuartzCore CoreGraphics

# Arquiteturas suportadas (foco total em iPhone 6s até o 16 Pro Max)
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
