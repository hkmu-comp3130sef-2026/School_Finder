package adapter_test

import (
	"context"
	"core/internal/adapter"
	"core/internal/domain"
	"core/pkg/pb"
	"path/filepath"
	"testing"

	"google.golang.org/protobuf/proto"
)

func TestContainer_InitializeAndReload(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	container := adapter.NewContainer(dbPath)
	ctx := context.Background()

	// Test initial initialization
	if err := container.Initialize(ctx); err != nil {
		t.Fatalf("Initialize failed: %v", err)
	}

	app := container.App()
	if app == nil {
		t.Fatal("App should not be nil after initialization")
	}

	// Test reload
	if err := container.Reload(ctx); err != nil {
		t.Fatalf("Reload failed: %v", err)
	}

	newApp := container.App()
	if newApp == nil {
		t.Fatal("App should not be nil after reload")
	}

	// Verify it's a new instance (reload creates fresh dependencies)
	// We can't directly compare pointers since it's a new instance

	// Test close
	if err := container.Close(); err != nil {
		t.Fatalf("Close failed: %v", err)
	}
}

func TestDispatcher_Actions(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	container := adapter.NewContainer(dbPath)
	ctx := context.Background()

	if err := container.Initialize(ctx); err != nil {
		t.Fatalf("Initialize failed: %v", err)
	}
	defer container.Close()

	dispatcher := adapter.NewDispatcher(container.App())

	// Test ACTION_GET_SETTINGS (should return defaults)
	resp, err := dispatcher.Dispatch(ctx, pb.Action_ACTION_GET_SETTINGS, nil)
	if err != nil {
		t.Fatalf("Get settings failed: %v", err)
	}

	settings, ok := resp.(*pb.UserSettings)
	if !ok {
		t.Fatalf("Expected UserSettings, got %T", resp)
	}
	if settings.Language != "en" {
		t.Errorf("Expected default language 'en', got '%s'", settings.Language)
	}

	// Test ACTION_UPDATE_SETTINGS
	updateReq := &pb.UserSettings{Language: "zh", ThemeMode: "dark", ColorSeed: "red"}
	payload, _ := proto.Marshal(updateReq)
	_, err = dispatcher.Dispatch(ctx, pb.Action_ACTION_UPDATE_SETTINGS, payload)
	if err != nil {
		t.Fatalf("Update settings failed: %v", err)
	}

	// Verify update
	resp, _ = dispatcher.Dispatch(ctx, pb.Action_ACTION_GET_SETTINGS, nil)
	settings = resp.(*pb.UserSettings)
	if settings.Language != "zh" {
		t.Errorf("Expected language 'zh', got '%s'", settings.Language)
	}

	// Test ACTION_GET_MAP_STATE (should return defaults)
	resp, err = dispatcher.Dispatch(ctx, pb.Action_ACTION_GET_MAP_STATE, nil)
	if err != nil {
		t.Fatalf("Get map state failed: %v", err)
	}

	mapState, ok := resp.(*pb.MapState)
	if !ok {
		t.Fatalf("Expected MapState, got %T", resp)
	}
	if mapState.ZoomLevel != 13.0 {
		t.Errorf("Expected default zoom 13.0, got %f", mapState.ZoomLevel)
	}
}

func TestMapper_Conversions(t *testing.T) {
	// Test School conversion
	domainSchool := &domain.School{
		ID:     123,
		NameEn: "Test School",
		NameZh: "測試學校",
	}

	pbSchool := adapter.SchoolToProto(domainSchool)
	if pbSchool.Id != 123 {
		t.Errorf("Expected ID 123, got %d", pbSchool.Id)
	}
	if pbSchool.NameEn != "Test School" {
		t.Errorf("Expected 'Test School', got '%s'", pbSchool.NameEn)
	}

	// Test round-trip
	backToDomain := adapter.ProtoToSchool(pbSchool)
	if backToDomain.ID != domainSchool.ID {
		t.Errorf("Round-trip failed: ID mismatch")
	}
	if backToDomain.NameZh != domainSchool.NameZh {
		t.Errorf("Round-trip failed: NameZh mismatch")
	}

	// Test nil handling
	if adapter.SchoolToProto(nil) != nil {
		t.Error("SchoolToProto(nil) should return nil")
	}
	if adapter.ProtoToSchool(nil) != nil {
		t.Error("ProtoToSchool(nil) should return nil")
	}

	// Test slice conversion
	schools := []*domain.School{domainSchool, {ID: 456, NameEn: "Another"}}
	pbSchools := adapter.SchoolsToProto(schools)
	if len(pbSchools) != 2 {
		t.Errorf("Expected 2 schools, got %d", len(pbSchools))
	}
}
