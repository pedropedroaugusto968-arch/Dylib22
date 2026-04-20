# Nome do projeto (Deve bater com o que está no arquivo 'control')
TWEAK_NAME = SpaceXitV4

# Configurações de compilação para iOS (Compatível com o main.yml)
# Usamos 'latest' para o SDK e '14.0' como mínimo para pegar arm64 e arm64e
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

# Arquivos e Flags
SpaceXitV4_FILES = Tweak.xm
SpaceXitV4_CFLAGS = -fobjc-arc

# Frameworks necessários
SpaceXitV4_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

# Removemos o killall daqui, pois o GitHub Actions vai apenas gerar o arquivo .deb
# Se quiser colocar algo após a compilação, use comandos de limpeza simples:
after-clean::
	rm -rf ./packages/*
