package mobile

import (
	"context"
	"core/internal/adapter"
	"core/pkg/pb"
	"fmt"
	"path/filepath"

	"google.golang.org/protobuf/proto"
)

// container holds the global DI container
var container *adapter.Container

// Init initializes the backend service.
// Returns empty string on success, error message otherwise.
func Init(appPath string) string {
	if container != nil {
		return ""
	}

	dbPath := filepath.Join(appPath, "schools.db")

	container = adapter.InitGlobalContainer(dbPath)
	ctx := context.Background()

	if err := container.Initialize(ctx); err != nil {
		return err.Error()
	}
	return ""
}

// Reload hot-reloads the service with fresh dependencies.
// This reinitializes all repositories and reloads data from persistence.
// Returns empty string on success, error message otherwise.
func Reload() string {
	if container == nil {
		return "backend not initialized"
	}
	ctx := context.Background()
	if err := container.Reload(ctx); err != nil {
		return err.Error()
	}
	return ""
}

// Call handles requests from Flutter.
// Includes panic recovery to prevent crashes from propagating to the host app.
func Call(input []byte) (result []byte) {
	// Panic recovery to protect the host Flutter app
	defer func() {
		if r := recover(); r != nil {
			result = makeErrorResponse(fmt.Sprintf("internal panic: %v", r))
		}
	}()

	if container == nil || container.App() == nil {
		return makeErrorResponse("backend not initialized")
	}

	reqEnvelope := &pb.RequestEnvelope{}
	if err := proto.Unmarshal(input, reqEnvelope); err != nil {
		return makeErrorResponse(fmt.Sprintf("invalid request envelope: %v", err))
	}

	// Create dispatcher with app instance
	ctx := context.Background()
	dispatcher := adapter.NewDispatcher(container.App())
	respMsg, err := dispatcher.Dispatch(ctx, reqEnvelope.Action, reqEnvelope.Payload)
	if err != nil {
		return makeErrorResponse(err.Error())
	}

	var payloadBytes []byte
	if respMsg != nil {
		payloadBytes, err = proto.Marshal(respMsg)
		if err != nil {
			return makeErrorResponse(fmt.Sprintf("failed to marshal payload: %v", err))
		}
	}

	respEnvelope := &pb.ResponseEnvelope{
		Success: true,
		Payload: payloadBytes,
	}

	out, err := proto.Marshal(respEnvelope)
	if err != nil {
		return []byte{}
	}
	return out
}

// Close releases all resources. Call this when the app is shutting down.
func Close() string {
	if container == nil {
		return ""
	}
	if err := container.Close(); err != nil {
		return err.Error()
	}
	container = nil
	return ""
}

func makeErrorResponse(msg string) []byte {
	env := &pb.ResponseEnvelope{
		Success: false,
		Error:   proto.String(msg),
	}
	out, _ := proto.Marshal(env)
	return out
}
