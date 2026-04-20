# Nome do projeto (Deve ser igual ao do arquivo .plist e do control)
TWEAK_NAME = SpaceXitV4

# Configurações de compilação para o GitHub Actions
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

# Arquivos que serão compilados
SpaceXitV4_FILES = Tweak.xm

# Flags de compilação
# A flag -Wno-deprecated-declarations resolve o erro de 'keyWindow' que deu no seu log
SpaceXitV4_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

# Frameworks necessários para o Menu e interface
SpaceXitV4_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

# Limpeza após compilação no servidor
after-clean::
	rm -rf ./packages/*
