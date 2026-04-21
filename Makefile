# Nome do projeto
TWEAK_NAME = SpaceXitV4

# Arquivos e Otimização
SpaceXitV4_FILES = Tweak.xm
SpaceXitV4_CFLAGS = -fobjc-arc -O3

# Flags de Linkagem para Bypass e Estabilidade
SpaceXitV4_LDFLAGS = -lsqlite3 -lz

# Configurações de Arquitetura e Target
export ARCHS = arm64
export TARGET = iphone:clang:latest:14.0
export THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
