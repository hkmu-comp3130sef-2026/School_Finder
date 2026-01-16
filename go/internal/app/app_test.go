package app_test

import (
	"context"
	"core/internal/app"
	"core/internal/domain"
	"core/internal/repository/memdb"
	"core/internal/repository/sqlite"
	"path/filepath"
	"testing"
)

func TestApp_Flows(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	// Create SQLite repository
	sqliteRepo, err := sqlite.NewSQLiteRepository(dbPath)
	if err != nil {
		t.Fatalf("Failed to create sqlite repo: %v", err)
	}
	defer sqliteRepo.Close()

	// Pre-populate with test data
	dummySchools := []*domain.School{
		{ID: 1, NameEn: "St. Paul's College", NameZh: "聖保羅書院", Latitude: 22.5, Longitude: 114.5, OriginalIDs: []int64{1}},
		{ID: 2, NameEn: "Queen's College", NameZh: "皇仁書院", Latitude: 22.51, Longitude: 114.51, OriginalIDs: []int64{2}},
	}
	if err := sqliteRepo.SaveSchools(context.Background(), dummySchools); err != nil {
		t.Fatalf("Failed to save schools: %v", err)
	}

	// Create memdb and sync
	schoolRepo := memdb.NewSchoolRepository()
	schools, _ := sqliteRepo.LoadSchools(context.Background())
	schoolRepo.SyncData(context.Background(), schools)

	// Create app with injected dependencies
	repos := app.Repositories{
		School:   schoolRepo,
		Favorite: sqliteRepo,
		Settings: sqliteRepo,
		Persist:  sqliteRepo,
	}
	application := app.New(app.DefaultConfig(), repos)

	ctx := context.Background()

	// Test 1: Search
	results, err := application.SearchSchools(ctx, "Paul")
	if err != nil {
		t.Fatalf("Search failed: %v", err)
	}
	if len(results) == 0 {
		t.Errorf("Search logic check: expected results for 'Paul', got 0")
	}

	// Test 2: Favorites
	if err := application.AddFavorite(ctx, 1); err != nil {
		t.Fatalf("Add Favorite failed: %v", err)
	}

	favSchools, err := application.GetFavoriteSchools(ctx)
	if err != nil {
		t.Fatalf("Get Favorites failed: %v", err)
	}
	if len(favSchools) != 1 {
		t.Errorf("Expected 1 favorite, got %d", len(favSchools))
	}

	// Test 3: Map State
	mapState := &domain.MapState{CenterLatitude: 22.5, CenterLongitude: 114.5, ZoomLevel: 15}
	if err := application.SaveMapState(ctx, mapState); err != nil {
		t.Fatalf("Save Map State failed: %v", err)
	}

	savedState, err := application.GetMapState(ctx)
	if err != nil {
		t.Fatalf("Get Map State failed: %v", err)
	}
	if savedState.ZoomLevel != 15 {
		t.Errorf("Map state persistence failed: expected zoom 15, got %f", savedState.ZoomLevel)
	}

	// Test 4: Settings
	settings := &domain.UserSettings{Language: "zh", ThemeMode: "dark", ColorSeed: "purple"}
	if err := application.UpdateSettings(ctx, settings); err != nil {
		t.Fatalf("Update Settings failed: %v", err)
	}

	savedSettings, err := application.GetSettings(ctx)
	if err != nil {
		t.Fatalf("Get Settings failed: %v", err)
	}
	if savedSettings.Language != "zh" {
		t.Errorf("Settings persistence failed: expected 'zh', got '%s'", savedSettings.Language)
	}

	// Test 5: Advanced Search
	criteria := &domain.AdvancedSearchCriteria{Name: "Queen"}
	advResults, err := application.AdvancedSearch(ctx, criteria)
	if err != nil {
		t.Fatalf("Advanced search failed: %v", err)
	}
	if len(advResults) != 1 {
		t.Errorf("Expected 1 result for Queen, got %d", len(advResults))
	}

	// Test 6: Get Nearby
	nearbyResults, err := application.GetNearbySchools(ctx, 22.5, 114.5, 50000)
	if err != nil {
		t.Fatalf("Get nearby failed: %v", err)
	}
	if len(nearbyResults) != 2 {
		t.Errorf("Expected 2 nearby schools, got %d", len(nearbyResults))
	}
}

func TestApp_FilterOptions(t *testing.T) {
	tmpDir := t.TempDir()
	dbPath := filepath.Join(tmpDir, "test.db")

	sqliteRepo, err := sqlite.NewSQLiteRepository(dbPath)
	if err != nil {
		t.Fatalf("Failed to create sqlite repo: %v", err)
	}
	defer sqliteRepo.Close()

	dummySchools := []*domain.School{
		{ID: 1, FinanceTypesEn: []string{"Aided"}, SessionsEn: []string{"AM"}, DistrictEn: "Central", OriginalIDs: []int64{1}},
		{ID: 2, FinanceTypesEn: []string{"DSS"}, SessionsEn: []string{"PM"}, DistrictEn: "Eastern", OriginalIDs: []int64{2}},
	}
	sqliteRepo.SaveSchools(context.Background(), dummySchools)

	schoolRepo := memdb.NewSchoolRepository()
	schools, _ := sqliteRepo.LoadSchools(context.Background())
	schoolRepo.SyncData(context.Background(), schools)

	repos := app.Repositories{
		School:   schoolRepo,
		Favorite: sqliteRepo,
		Settings: sqliteRepo,
		Persist:  sqliteRepo,
	}
	application := app.New(app.DefaultConfig(), repos)

	options, err := application.GetFilterOptions(context.Background())
	if err != nil {
		t.Fatalf("Get filter options failed: %v", err)
	}

	if len(options.FinanceTypes) != 2 {
		t.Errorf("Expected 2 finance types, got %d", len(options.FinanceTypes))
	}
	if len(options.Sessions) != 2 {
		t.Errorf("Expected 2 sessions, got %d", len(options.Sessions))
	}
	if len(options.Districts) != 2 {
		t.Errorf("Expected 2 districts, got %d", len(options.Districts))
	}
}
