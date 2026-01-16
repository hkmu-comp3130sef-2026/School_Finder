package app

import (
	"context"
	"core/internal/domain"
	"core/internal/logger"
	"encoding/json"
	"fmt"
	"net/http"
)

// Config holds application configuration
type Config struct {
	SchoolDataURL string
}

// DefaultConfig returns the default configuration
func DefaultConfig() Config {
	return Config{
		SchoolDataURL: "https://www.edb.gov.hk/attachment/en/student-parents/sch-info/sch-search/sch-location-info/SCH_LOC_EDB.json",
	}
}

// Repositories groups all repository dependencies
type Repositories struct {
	School     domain.SchoolRepository
	Favorite   domain.FavoriteRepository
	Settings   domain.SettingsRepository
	Persist    domain.SchoolPersistenceRepository
	HTTPClient *http.Client
}

// App is the main application service
// It contains all use cases and depends only on domain interfaces
type App struct {
	cfg   Config
	repos Repositories
}

// New creates a new App with injected dependencies
func New(cfg Config, repos Repositories) *App {
	if repos.HTTPClient == nil {
		repos.HTTPClient = http.DefaultClient
	}
	return &App{
		cfg:   cfg,
		repos: repos,
	}
}

// ReloadData fetches, persists, and syncs school data using default URL
// Context allows for cancellation and timeout control from frontend
func (a *App) ReloadData(ctx context.Context) error {
	return a.ReloadDataFromURL(ctx, a.cfg.SchoolDataURL)
}

// ReloadDataFromURL fetches data from a specific URL
func (a *App) ReloadDataFromURL(ctx context.Context, url string) error {
	logger.Get().I("App", "Fetching content from URL: %s", url)
	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	resp, err := a.repos.HTTPClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to download data: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		logger.Get().E("App", "Bad status code", fmt.Errorf("status: %s", resp.Status))
		return fmt.Errorf("bad status: %s", resp.Status)
	}
	logger.Get().D("App", "Response status: %s", resp.Status)

	var rawData []domain.RawSchoolData
	if err := json.NewDecoder(resp.Body).Decode(&rawData); err != nil {
		return fmt.Errorf("failed to parse json: %w", err)
	}
	logger.Get().I("App", "Decoded %d raw schools", len(rawData))

	schools := make([]*domain.School, 0, len(rawData))
	for _, d := range rawData {
		schools = append(schools, d.ToSchool())
	}

	// Save raw schools (as fetched)
	if err := a.repos.Persist.SaveSchools(ctx, schools); err != nil {
		return fmt.Errorf("failed to persist raw schools: %w", err)
	}
	logger.Get().I("App", "Persisted %d raw schools", len(schools))

	// Group schools by location to merge duplicate pins
	groupedSchools := domain.GroupSchoolsByLocation(schools)

	// Persist grouped schools
	if err := a.repos.Persist.SaveGroupedSchools(ctx, groupedSchools); err != nil {
		return fmt.Errorf("failed to persist grouped schools: %w", err)
	}
	logger.Get().I("App", "Persisted %d grouped schools", len(groupedSchools))

	// Sync grouped data to memory
	if err := a.repos.School.SyncData(ctx, groupedSchools); err != nil {
		return fmt.Errorf("failed to sync memory: %w", err)
	}
	logger.Get().I("App", "Synced data to memory")

	return nil
}

// GetNearbySchools returns schools within range
func (a *App) GetNearbySchools(ctx context.Context, lat, lng, rangeMeters float64) ([]*domain.SchoolWithDistance, error) {
	return a.repos.School.GetNearby(ctx, lat, lng, rangeMeters)
}

// GetSchoolByID returns a school by ID
func (a *App) GetSchoolByID(ctx context.Context, id int64) (*domain.School, error) {
	return a.repos.School.GetById(ctx, id)
}

// SearchSchools performs basic search
func (a *App) SearchSchools(ctx context.Context, keyword string) ([]*domain.School, error) {
	return a.repos.School.Search(ctx, keyword)
}

// AdvancedSearch performs advanced search
func (a *App) AdvancedSearch(ctx context.Context, criteria *domain.AdvancedSearchCriteria) ([]*domain.School, error) {
	return a.repos.School.AdvancedSearch(ctx, criteria)
}

// GetFilterOptions returns available filter options
func (a *App) GetFilterOptions(ctx context.Context) (*domain.FilterOptions, error) {
	// Try to get current language setting
	lang := "en"
	if settings, err := a.repos.Settings.GetSettings(ctx); err == nil && settings != nil {
		lang = settings.Language
	}
	return a.repos.School.GetFilterOptions(ctx, lang)
}

// GetFavoriteSchools returns all favorited schools
func (a *App) GetFavoriteSchools(ctx context.Context) ([]*domain.School, error) {
	ids, err := a.repos.Favorite.GetFavoriteIDs(ctx)
	if err != nil {
		return nil, err
	}
	schools := make([]*domain.School, 0, len(ids))
	for _, id := range ids {
		school, _ := a.repos.School.GetById(ctx, id)
		if school != nil {
			schools = append(schools, school)
		}
	}
	return schools, nil
}

// AddFavorite adds a school to favorites
func (a *App) AddFavorite(ctx context.Context, schoolID int64) error {
	return a.repos.Favorite.AddFavorite(ctx, schoolID)
}

// RemoveFavorite removes a school from favorites
func (a *App) RemoveFavorite(ctx context.Context, schoolID int64) error {
	return a.repos.Favorite.RemoveFavorite(ctx, schoolID)
}

// GetSettings returns user settings
func (a *App) GetSettings(ctx context.Context) (*domain.UserSettings, error) {
	return a.repos.Settings.GetSettings(ctx)
}

// UpdateSettings saves user settings
func (a *App) UpdateSettings(ctx context.Context, settings *domain.UserSettings) error {
	return a.repos.Settings.UpdateSettings(ctx, settings)
}

// GetMapState returns map state
func (a *App) GetMapState(ctx context.Context) (*domain.MapState, error) {
	return a.repos.Settings.GetMapState(ctx)
}

// SaveMapState saves map state
func (a *App) SaveMapState(ctx context.Context, state *domain.MapState) error {
	return a.repos.Settings.SaveMapState(ctx, state)
}
