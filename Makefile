# Flutter School App - Build System
# ==============================================================================

# --- Configuration & Environment ----------------------------------------------
APP_NAME       := School Finder
BUILD_DIR      := build
GO_DIR         := go
PROTO_DIR      := protos

# Paths - Generated Content
GO_PB_DIR      := $(GO_DIR)/pkg/pb
DART_PB_DIR    := lib/models/pb
ANDROID_AAR    := android/app/libs/libcore.aar
IOS_FRAMEWORK  := ios/Frameworks/Mobile.xcframework

# Paths - Outputs
ANDROID_OUTPUT := $(BUILD_DIR)/app/outputs/flutter-apk
IOS_OUTPUT     := $(BUILD_DIR)/ios/ipa
IOS_ARCHIVE    := $(BUILD_DIR)/ios/archive/Runner.xcarchive

# Commands & Platform Handling
GO      := go
PROTOC  := protoc
ifeq ($(OS),Windows_NT)
    FLUTTER := flutter.bat
    DART    := dart.bat
    RM      := del /Q /F
    RM_DIR  := rmdir /S /Q
else
    FLUTTER := flutter
    DART    := dart
    RM      := rm -f
    RM_DIR  := rm -rf
endif

# --- Macros -------------------------------------------------------------------
define LOG
	@echo "➡️  $(1)"
endef

define CHECK_TOOL
	@which $(1) > /dev/null || { echo "❌ $(1) not found. Please install it."; exit 1; }
endef

# --- Main Targets -------------------------------------------------------------
.PHONY: all help setup check clean deps dev
.PHONY: gen-proto clean-proto aar framework apk ipa

all: help

help: ## Show this help message
	@echo "Flutter School App Build System"
	@echo "==============================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# --- Setup & Dependencies -----------------------------------------------------
check: ## Verify environment dependencies
	$(call LOG,"Checking dependencies...")
	$(call CHECK_TOOL,$(GO))
	$(call CHECK_TOOL,protoc)
	@echo "✅ Core dependencies found."

setup: check ## Install Go mobile tools and dependencies
	$(call LOG,"Setting up Go dependencies...")
	cd $(GO_DIR) && $(GO) mod tidy
	$(call LOG,"Initializing gomobile...")
	$(GO) install golang.org/x/mobile/cmd/gomobile@latest
	gomobile init
	$(call LOG,"Checking Protobuf plugins...")
	$(GO) install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	$(DART) pub global activate protoc_plugin
	$(call LOG,"Setup complete!")

deps: ## Update Dart and Go dependencies
	$(FLUTTER) pub get
	cd $(GO_DIR) && $(GO) mod tidy
	$(call LOG,"Dependencies updated.")

# --- Code Generation ----------------------------------------------------------
gen-proto: ## Generate Go and Dart protobuf files
	$(call LOG,"Generating protobuf code...")
	@mkdir -p $(GO_PB_DIR) $(DART_PB_DIR)
	$(PROTOC) --proto_path=$(PROTO_DIR) \
		--go_out=$(GO_PB_DIR) --go_opt=paths=source_relative \
		--dart_out=$(DART_PB_DIR) \
		$(PROTO_DIR)/*.proto
	$(call LOG,"Protobuf generation complete.")

clean-proto: ## Clean generated protobuf files
	$(call LOG,"Cleaning generated protobuf files...")
	$(RM) $(GO_PB_DIR)/*.pb.go
	$(RM) $(DART_PB_DIR)/*.pb.dart

# --- Native Bindings (Go Mobile) ----------------------------------------------
aar: gen-proto ## Build Go AAR for Android
	$(call LOG,"Building Go AAR for Android...")
	cd $(GO_DIR) && gomobile bind -target=android -androidapi 21 -o ../$(ANDROID_AAR) ./mobile
	$(call LOG,"AAR built: $(ANDROID_AAR)")

framework: gen-proto ## Build Go framework for iOS
	$(call LOG,"Building Go framework for iOS...")
	cd $(GO_DIR) && gomobile bind -target=ios -o ../$(IOS_FRAMEWORK) ./mobile
	$(call LOG,"iOS framework built!")

# --- Application Builds -------------------------------------------------------
apk: aar deps ## Build release APK
	$(call LOG,"Building release APK...")
	$(FLUTTER) build apk --release
	$(call LOG,"Output: $(ANDROID_OUTPUT)/app-release.apk")

ipa: framework deps ## Build unsigned IPA (manual packaging)
	$(call LOG,"Building unsigned IPA...")
	$(FLUTTER) build ipa --release --no-codesign
	$(call LOG,"Packaging IPA...")
	@mkdir -p Payload
	@cp -r $(IOS_ARCHIVE)/Products/Applications/Runner.app Payload/
	@mkdir -p $(IOS_OUTPUT)
	@zip -r $(IOS_OUTPUT)/SchoolFinder.ipa Payload
	@$(RM_DIR) Payload
	$(call LOG,"Output: $(IOS_OUTPUT)/SchoolFinder.ipa")

# --- Development & Maintenance ------------------------------------------------
clean: clean-proto ## Clean all build artifacts
	$(FLUTTER) clean
	$(call LOG,"Build artifacts cleaned.")

dev: aar ## Launch development environment (auto-emulator)
	$(call LOG,"Looking for emulators...")
	@if [ -n "$$($(FLUTTER) emulators | grep "•" | grep -v "Id")" ]; then \
		EMULATOR_ID=$$($(FLUTTER) emulators | grep "•" | grep -v "Id" | head -n 1 | awk '{print $$1}'); \
		echo "📱 Launching emulator: $$EMULATOR_ID"; \
		$(FLUTTER) emulators --launch $$EMULATOR_ID; \
	else \
		echo "📱 No emulator found. Using connected device."; \
	fi
	$(FLUTTER) run
