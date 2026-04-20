# Nome do projeto
TWEAK_NAME = SpaceXitV4

# Arquivos que serão compilados (Certifique-se que o nome é Tweak.xm)
SpaceXitV4_FILES = Tweak.xm
SpaceXitV4_CFLAGS = -fobjc-arc

# Frameworks necessários para o Menu e o ESP
SpaceXitV4_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore

# Configurações de compilação para iOS Moderno
export TARGET = iphone:clang:14.5:14.0
export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
