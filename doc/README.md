# School Finder

A Flutter-based application for finding schools, featuring OpenStreetMap integration, robust location services, and offline capabilities powered by a Go backend.

## Architecture

This project uses a hybrid architecture:

- **Frontend**: Flutter (UI, Map, State Management)
- **Backend**: Go (Business Logic, SQLite Database, Data Processing)
- **Bridge**: `gomobile` (Communication between Dart and Go via generated bindings)
- **Data Exchange**: Protocol Buffers (Protobuf) for type-safe data serialization

## Build Instructions

For detailed instructions on prerequisites, setup, development commands, and building for release, please refer to [BUILD.md](doc/BUILD/BUILD.md).

## Project Structure

- `lib/`: Flutter source code (UI, Providers, Models).
- `go/`: Go source code (Core logic, Database, Search).
  - `cmd/`: Entry points.
  - `internal/`: Private application code.
  - `mobile/`: Exported API for Gomobile bindings.
- `protos/`: Protocol Buffer definitions.
- `android/` & `ios/`: Platform-specific configuration.
- `doc/`: Documentation.

## Contributing

We welcome contributions! Please read our [Contributing Guidelines](doc/Contributing/CONTRIBUTING.md) for details on how to submit pull requests, report issues, and the code of conduct.
