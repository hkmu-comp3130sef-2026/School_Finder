# Contributing to School Finder

This project is a hybrid application using **Flutter** for the UI and **Go** for the backend logic, bridged via `gomobile`.

## 🚀 Architecture Overview

- **Frontend**: Flutter (Dart) located in `lib/`.
- **Backend**: Go located in `go/`.
- **Bridge**: Communication happens via Protocol Buffers defined in `protos/`.
  - Flutter calls Go functions exposed via `gomobile`.
  - Data is serialized/deserialized using Protobuf.

## 🛠 Build & Setup

For detailed instructions on setting up your environment, running the app, and building for release, please refer to **[BUILD.md](../../BUILD.md)**.

## 🧪 Testing

### Flutter Tests

```bash
flutter test
```

### Go Backend Tests

```bash
cd go
go test ./...
```
