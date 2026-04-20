# Nome do projeto (deve ser o mesmo do seu .plist)
TWEAK_NAME = SucSoftFFH4X

# Arquivos que serão compilados (o menu com abas)
SucSoftFFH4X_FILES = Tweak.xm
# Ativa o ARC (essencial para o menu com abas não crashar)
SucSoftFFH4X_CFLAGS = -fobjc-arc -O3

# Frameworks que desenham o menu e as abas na tela
SucSoftFFH4X_FRAMEWORKS = UIKit QuartzCore CoreGraphics Foundation

# Arquiteturas para rodar do iPhone 7 ao 16 Pro Max
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
