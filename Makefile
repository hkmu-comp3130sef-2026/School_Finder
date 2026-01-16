# Flutter School App - Build Makefile
# For GitHub Releases
# ===================================

# Configuration
APP_NAME := School Finder
BUILD_DIR := build
ANDROID_OUTPUT := $(BUILD_DIR)/app/outputs/flutter-apk
IOS_OUTPUT := $(BUILD_DIR)/ios/ipa
GO_DIR := go
AAR_OUTPUT := android/app/libs

# ===================================
# HELP
# ===================================
.PHONY: help
help:
	@echo "Flutter Build Makefile (GitHub Release)"
	@echo "========================================"
	@echo ""
	@echo "Go Backend Commands:"
	@echo "  make aar              - Build Go AAR for Android"
	@echo "  make framework        - Build Go framework for iOS"
	@echo ""
	@echo "Android Commands:"
	@echo "  make apk              - Build release APK (includes AAR build)"
	@echo "  make apk-debug        - Build debug APK"
	@echo ""
	@echo "iOS Commands:"
	@echo "  make ipa              - Build unsigned IPA (includes framework build)"
	@echo "  make ipa-debug        - Build debug iOS app"
	@echo ""
	@echo "Common Commands:"
	@echo "  make clean            - Clean build artifacts"
	@echo "  make deps             - Get Flutter dependencies"
	@echo ""
	@echo "iOS Sideloading Note:"
	@echo "  The unsigned IPA can be installed using AltStore or Sideloadly"
	@echo "  with a free Apple ID (valid for 7 days, re-sign required)"

# ===================================
# COMMON
# ===================================
.PHONY: clean deps

clean:
	flutter clean
	@echo "Build artifacts cleaned."

deps:
	flutter pub get
	@echo "Dependencies updated."

# ===================================
# GO MOBILE BUILDS
# ===================================
.PHONY: aar framework

# Build Go AAR for Android
aar:
	@echo "Building Go AAR for Android..."
	cd $(GO_DIR) && gomobile bind -target=android -androidapi 21 -o ../$(AAR_OUTPUT)/libcore.aar ./mobile
	@echo "AAR built: $(AAR_OUTPUT)/libcore.aar"

# Build Go framework for iOS
framework:
	@echo "Building Go framework for iOS..."
	cd $(GO_DIR) && gomobile bind -target=ios -o ../ios/Frameworks/Mobile.xcframework ./mobile
	@echo "iOS framework built!"

# ===================================
# ANDROID BUILDS
# ===================================
.PHONY: apk apk-debug

# Build release APK (includes AAR build)
apk: aar deps
	@echo "Building release APK..."
	flutter build apk --release
	@echo ""
	@echo "APK built successfully!"
	@echo "Output: $(ANDROID_OUTPUT)/app-release.apk"

# Build debug APK
apk-debug: aar deps
	@echo "Building debug APK..."
	flutter build apk --debug
	@echo ""
	@echo "Debug APK built!"
	@echo "Output: $(ANDROID_OUTPUT)/app-debug.apk"

# ===================================
# iOS BUILDS (Unsigned for Sideloading)
# ===================================
.PHONY: ipa ipa-debug

# Build unsigned IPA (includes framework build)
ipa: framework deps
	@echo "Building unsigned IPA..."
	flutter build ipa --release --no-codesign
	@echo ""
	@echo "Unsigned IPA built successfully!"
	@echo "Output: $(IOS_OUTPUT)/"
	@echo ""
	@echo "Users can install this IPA using:"
	@echo "  - AltStore (https://altstore.io/)"
	@echo "  - Sideloadly (https://sideloadly.io/)"
	@echo "  With their Apple ID (7-day validity, re-sign required)"

# Build debug iOS app
ipa-debug: framework deps
	@echo "Building debug iOS app..."
	flutter build ios --debug --no-codesign
	@echo ""
	@echo "Debug iOS build complete!"