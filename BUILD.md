# Build Instructions

This document covers the build system, prerequisites, and commands for the School Finder application.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.10.7 or later)
- **Go** (1.25 or later)
- **Protoc** (Protocol Buffers Compiler)
  - _MacOS_: `brew install protobuf`
  - _Windows_: `choco install protoc` or `winget install protobuf`
- **Make** (Recommended for build automation)
- **Android Studio / Xcode** (for mobile development)

## Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/hkmu-comp3130sef-2026/School_Finder.git
   cd School_Finder
   ```

2. **Initialize Dependencies:**
   Run the setup command to install Go dependencies, initialize `gomobile`, and install Protobuf plugins.

   ```bash
   make setup
   ```

3. **Install Application Dependencies:**
   ```bash
   make deps
   ```

## Development

To run the application in development mode with the Go backend:

```bash
make dev
```

This command builds the Go AAR/Framework bindings and launches the Flutter app on an available emulator or connected device.

### Code Generation

If you modify `.proto` files in the `protos/` directory, regenerate the Go and Dart code:

```bash
make gen-proto
```

## Building for Release

### Android (APK)

```bash
make apk
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS (IPA)

```bash
make ipa
```

_Note: This builds an unsigned IPA for manual testing/distribution._
Output: `build/ios/ipa/SchoolFinder.ipa`

## Maintenance

To clean up all build artifacts:

```bash
make clean
```
