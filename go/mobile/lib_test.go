package mobile

import (
	"core/pkg/pb"
	"strings"
	"testing"

	"google.golang.org/protobuf/proto"
)

// resetGlobalState resets the global container state for test isolation
func resetGlobalState() {
	if container != nil {
		container.Close()
		container = nil
	}
}

func TestInit_Success(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Use temp directory for test database
	result := Init(t.TempDir())
	if result != "" {
		t.Errorf("Init() returned error: %s", result)
	}
}

func TestInit_AlreadyInitialized(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	tempDir := t.TempDir()

	// First init
	result1 := Init(tempDir)
	if result1 != "" {
		t.Fatalf("First Init() returned error: %s", result1)
	}

	// Second init should return empty (already initialized)
	result2 := Init(tempDir)
	if result2 != "" {
		t.Errorf("Second Init() should return empty string, got: %s", result2)
	}
}

func TestCall_NotInitialized(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Call without Init should return error response
	result := Call([]byte{})

	resp := &pb.ResponseEnvelope{}
	if err := proto.Unmarshal(result, resp); err != nil {
		t.Fatalf("Failed to unmarshal response: %v", err)
	}

	if resp.Success {
		t.Error("Expected Success to be false when not initialized")
	}

	if resp.Error == nil || !strings.Contains(*resp.Error, "backend not initialized") {
		t.Errorf("Expected 'backend not initialized' error, got: %v", resp.Error)
	}
}

func TestCall_InvalidRequest(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Send invalid protobuf data
	result := Call([]byte{0xFF, 0xFF, 0xFF})

	resp := &pb.ResponseEnvelope{}
	if err := proto.Unmarshal(result, resp); err != nil {
		t.Fatalf("Failed to unmarshal response: %v", err)
	}

	if resp.Success {
		t.Error("Expected Success to be false for invalid request")
	}

	if resp.Error == nil || !strings.Contains(*resp.Error, "invalid request envelope") {
		t.Errorf("Expected 'invalid request envelope' error, got: %v", resp.Error)
	}
}

func TestCall_ValidRequest_GetSettings(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Create a valid request for ACTION_GET_SETTINGS (no payload needed)
	reqEnvelope := &pb.RequestEnvelope{
		Action:  pb.Action_ACTION_GET_SETTINGS,
		Payload: nil,
	}
	reqBytes, err := proto.Marshal(reqEnvelope)
	if err != nil {
		t.Fatalf("Failed to marshal request: %v", err)
	}

	result := Call(reqBytes)

	resp := &pb.ResponseEnvelope{}
	if err := proto.Unmarshal(result, resp); err != nil {
		t.Fatalf("Failed to unmarshal response: %v", err)
	}

	if !resp.Success {
		t.Errorf("Expected Success to be true, got error: %v", resp.Error)
	}
}

func TestCall_ValidRequest_GetMapState(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Create a valid request for ACTION_GET_MAP_STATE
	reqEnvelope := &pb.RequestEnvelope{
		Action:  pb.Action_ACTION_GET_MAP_STATE,
		Payload: nil,
	}
	reqBytes, err := proto.Marshal(reqEnvelope)
	if err != nil {
		t.Fatalf("Failed to marshal request: %v", err)
	}

	result := Call(reqBytes)

	resp := &pb.ResponseEnvelope{}
	if err := proto.Unmarshal(result, resp); err != nil {
		t.Fatalf("Failed to unmarshal response: %v", err)
	}

	if !resp.Success {
		t.Errorf("Expected Success to be true, got error: %v", resp.Error)
	}
}

func TestCall_UnknownAction(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Create a request with ACTION_UNSPECIFIED
	reqEnvelope := &pb.RequestEnvelope{
		Action:  pb.Action_ACTION_UNSPECIFIED,
		Payload: nil,
	}
	reqBytes, err := proto.Marshal(reqEnvelope)
	if err != nil {
		t.Fatalf("Failed to marshal request: %v", err)
	}

	result := Call(reqBytes)

	resp := &pb.ResponseEnvelope{}
	if err := proto.Unmarshal(result, resp); err != nil {
		t.Fatalf("Failed to unmarshal response: %v", err)
	}

	if resp.Success {
		t.Error("Expected Success to be false for unknown action")
	}

	if resp.Error == nil || !strings.Contains(*resp.Error, "unknown action") {
		t.Errorf("Expected 'unknown action' error, got: %v", resp.Error)
	}
}

func TestCall_GetFilterOptions(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Create a valid request for ACTION_GET_FILTER_OPTIONS
	reqEnvelope := &pb.RequestEnvelope{
		Action:  pb.Action_ACTION_GET_FILTER_OPTIONS,
		Payload: nil,
	}
	reqBytes, err := proto.Marshal(reqEnvelope)
	if err != nil {
		t.Fatalf("Failed to marshal request: %v", err)
	}

	result := Call(reqBytes)

	resp := &pb.ResponseEnvelope{}
	if err := proto.Unmarshal(result, resp); err != nil {
		t.Fatalf("Failed to unmarshal response: %v", err)
	}

	if !resp.Success {
		t.Errorf("Expected Success to be true, got error: %v", resp.Error)
	}

	// Verify we can decode the filter options response
	if resp.Payload != nil {
		filterOpts := &pb.FilterOptionsResponse{}
		if err := proto.Unmarshal(resp.Payload, filterOpts); err != nil {
			t.Errorf("Failed to unmarshal filter options: %v", err)
		}
	}
}

func TestCall_GetFavoriteSchools(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Create a valid request for ACTION_GET_FAVORITE_SCHOOLS
	reqEnvelope := &pb.RequestEnvelope{
		Action:  pb.Action_ACTION_GET_FAVORITE_SCHOOLS,
		Payload: nil,
	}
	reqBytes, err := proto.Marshal(reqEnvelope)
	if err != nil {
		t.Fatalf("Failed to marshal request: %v", err)
	}

	result := Call(reqBytes)

	resp := &pb.ResponseEnvelope{}
	if err := proto.Unmarshal(result, resp); err != nil {
		t.Fatalf("Failed to unmarshal response: %v", err)
	}

	if !resp.Success {
		t.Errorf("Expected Success to be true, got error: %v", resp.Error)
	}
}

func TestReload_Success(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Reload should succeed
	result := Reload()
	if result != "" {
		t.Errorf("Reload() returned error: %s", result)
	}
}

func TestReload_NotInitialized(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Reload without init should return error
	result := Reload()
	if result == "" {
		t.Error("Expected Reload() to return error when not initialized")
	}
	if !strings.Contains(result, "not initialized") {
		t.Errorf("Expected 'not initialized' error, got: %s", result)
	}
}

func TestClose_Success(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Close should succeed
	result := Close()
	if result != "" {
		t.Errorf("Close() returned error: %s", result)
	}

	// Container should be nil after close
	if container != nil {
		t.Error("Expected container to be nil after Close()")
	}
}

func TestMakeErrorResponse(t *testing.T) {
	testMsg := "test error message"
	result := makeErrorResponse(testMsg)

	resp := &pb.ResponseEnvelope{}
	if err := proto.Unmarshal(result, resp); err != nil {
		t.Fatalf("Failed to unmarshal response: %v", err)
	}

	if resp.Success {
		t.Error("Expected Success to be false")
	}

	if resp.Error == nil {
		t.Fatal("Expected Error to be set")
	}

	if *resp.Error != testMsg {
		t.Errorf("Expected error message '%s', got '%s'", testMsg, *resp.Error)
	}
}

// TestCall_ResponseFormat verifies that Call always returns a valid protobuf response
func TestCall_ResponseFormat(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	testCases := []struct {
		name         string
		setup        func()
		input        []byte
		expectResult bool // whether we expect a parseable response
	}{
		{
			name:         "Empty input, not initialized",
			setup:        func() {},
			input:        []byte{},
			expectResult: true,
		},
		{
			name: "Empty input, initialized",
			setup: func() {
				Init(t.TempDir())
			},
			input:        []byte{},
			expectResult: true,
		},
		{
			name: "Garbage input, initialized",
			setup: func() {
				Init(t.TempDir())
			},
			input:        []byte{0x00, 0x01, 0x02, 0x03, 0x04},
			expectResult: true,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			resetGlobalState()
			tc.setup()

			result := Call(tc.input)

			// Result should never be nil
			if result == nil {
				t.Fatal("Call returned nil")
			}

			// Result should always be unmarshalable to ResponseEnvelope
			resp := &pb.ResponseEnvelope{}
			if err := proto.Unmarshal(result, resp); err != nil {
				t.Errorf("Failed to unmarshal response: %v", err)
			}
		})
	}
}

// TestCall_Concurrency tests thread safety of the Call function
func TestCall_Concurrency(t *testing.T) {
	resetGlobalState()
	defer resetGlobalState()

	// Initialize first
	if result := Init(t.TempDir()); result != "" {
		t.Fatalf("Init failed: %s", result)
	}

	// Create a valid request
	reqEnvelope := &pb.RequestEnvelope{
		Action:  pb.Action_ACTION_GET_SETTINGS,
		Payload: nil,
	}
	reqBytes, err := proto.Marshal(reqEnvelope)
	if err != nil {
		t.Fatalf("Failed to marshal request: %v", err)
	}

	// Run multiple concurrent calls
	done := make(chan bool, 10)
	for i := 0; i < 10; i++ {
		go func() {
			result := Call(reqBytes)
			resp := &pb.ResponseEnvelope{}
			if err := proto.Unmarshal(result, resp); err != nil {
				t.Errorf("Failed to unmarshal response: %v", err)
			}
			if !resp.Success {
				t.Errorf("Expected Success to be true, got error: %v", resp.Error)
			}
			done <- true
		}()
	}

	// Wait for all goroutines to complete
	for i := 0; i < 10; i++ {
		<-done
	}
}
