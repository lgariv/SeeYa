TARGET = iphone:clang:13.1
ARCHS = arm64 arm64e

FINALPACKAGE = 1

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ContactNotif

ContactNotif_FILES = Tweak.xm FolderFinder.m
ContactNotif_FRAMEWORKS = UIKit
ContactNotif_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
