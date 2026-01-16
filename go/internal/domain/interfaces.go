package domain

import (
	"context"
)

// SchoolRepository provides read access to school data
type SchoolRepository interface {
	GetNearby(ctx context.Context, lat, lng, rangeMeters float64) ([]*SchoolWithDistance, error)
	GetById(ctx context.Context, id int64) (*School, error)
	Search(ctx context.Context, keyword string) ([]*School, error)
	AdvancedSearch(ctx context.Context, criteria *AdvancedSearchCriteria) ([]*School, error)
	GetFilterOptions(ctx context.Context, language string) (*FilterOptions, error)
	SyncData(ctx context.Context, schools []*School) error
}

// FavoriteRepository manages user favorites
type FavoriteRepository interface {
	GetFavoriteIDs(ctx context.Context) ([]int64, error)
	AddFavorite(ctx context.Context, schoolID int64) error
	RemoveFavorite(ctx context.Context, schoolID int64) error
}

// SettingsRepository manages user settings
type SettingsRepository interface {
	GetSettings(ctx context.Context) (*UserSettings, error)
	UpdateSettings(ctx context.Context, settings *UserSettings) error
	GetMapState(ctx context.Context) (*MapState, error)
	SaveMapState(ctx context.Context, state *MapState) error
}

// SchoolPersistenceRepository handles school data persistence
type SchoolPersistenceRepository interface {
	// SaveSchools saves raw school data (individual schools)
	SaveSchools(ctx context.Context, schools []*School) error

	// SaveGroupedSchools saves grouped school data (merged pins)
	SaveGroupedSchools(ctx context.Context, schools []*School) error

	// LoadSchools loads raw school data
	LoadSchools(ctx context.Context) ([]*School, error)

	// LoadGroupedSchools loads grouped school data
	LoadGroupedSchools(ctx context.Context) ([]*School, error)

	AdvancedSearch(ctx context.Context, criteria *AdvancedSearchCriteria) ([]*School, error)
}

// Closeable for resources that need cleanup
type Closeable interface {
	Close() error
}
