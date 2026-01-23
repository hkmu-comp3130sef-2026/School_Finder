module core

go 1.25.5

require (
	github.com/mattn/go-sqlite3 v1.14.33
	github.com/sirupsen/logrus v1.9.4
	google.golang.org/protobuf v1.36.11
)

require (
	golang.org/x/mobile v0.0.0-20260120165949-40bd9ace6ce4 // indirect
	golang.org/x/mod v0.32.0 // indirect
	golang.org/x/sync v0.19.0 // indirect
	golang.org/x/sys v0.40.0 // indirect
	golang.org/x/tools v0.41.0 // indirect
)

tool (
	golang.org/x/mobile/bind
	golang.org/x/mobile/cmd/gomobile
	google.golang.org/protobuf/cmd/protoc-gen-go
)
