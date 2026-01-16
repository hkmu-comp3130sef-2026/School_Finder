package adapter

import (
	"context"
	"core/internal/app"
	"core/internal/domain"
	"core/internal/logger"
	"core/internal/repository/memdb"
	"core/internal/repository/sqlite"
	"fmt"
	"sync"
)

// Container manages the application lifecycle and dependency assembly
// This is the composition root for the DDD architecture
type Container struct {
	mu      sync.RWMutex
	app     *app.App
	dbPath  string
	closers []func() error
}

// NewContainer creates a new dependency injection container
func NewContainer(dbPath string) *Container {
	return &Container{
		dbPath: dbPath,
	}
}

// Initialize sets up all dependencies and the application
func (c *Container) Initialize(ctx context.Context) error {
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.app != nil {
		return nil // Already initialized
	}

	// Create SQLite repository (infrastructure layer)
	sqliteRepo, err := sqlite.NewSQLiteRepository(c.dbPath)
	if err != nil {
		return fmt.Errorf("failed to init sqlite: %w", err)
	}
	c.closers = append(c.closers, sqliteRepo.Close)

	// Create in-memory repository
	schoolRepo := memdb.NewSchoolRepository()

	// Load initial data from persistence to memory
	// Try loading pre-calculated groups first
	schools, err := sqliteRepo.LoadGroupedSchools(ctx)
	if err == nil && len(schools) > 0 {
		logger.Get().I("Container", "Loaded %d grouped schools", len(schools))
		_ = schoolRepo.SyncData(ctx, schools)
	} else {
		// Fallback: try loading raw data (if grouped table is empty/new)
		logger.Get().I("Container", "No grouped schools, checking raw data...")
		rawSchools, err := sqliteRepo.LoadSchools(ctx)
		if err == nil && len(rawSchools) > 0 {
			logger.Get().I("Container", "Found %d raw schools, grouping and migrating...", len(rawSchools))
			grouped := domain.GroupSchoolsByLocation(rawSchools)
			// Save for next time
			if err := sqliteRepo.SaveGroupedSchools(ctx, grouped); err != nil {
				logger.Get().E("Container", "Failed to save groups during migration", err)
			}
			_ = schoolRepo.SyncData(ctx, grouped)
		} else {
			logger.Get().I("Container", "No data found")
		}
	}

	// Assemble repositories - this is the composition root
	repos := app.Repositories{
		School:   schoolRepo,
		Favorite: sqliteRepo,
		Settings: sqliteRepo,
		Persist:  sqliteRepo,
	}

	// Create application service with injected dependencies
	c.app = app.New(app.DefaultConfig(), repos)

	return nil
}

// App returns the application service (thread-safe)
func (c *Container) App() *app.App {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.app
}

// Reload reinitializes the container with fresh dependencies
// This is the hot reload feature for frontend - context passthrough supported
func (c *Container) Reload(ctx context.Context) error {
	// Close existing resources
	if err := c.Close(); err != nil {
		// Log but continue - best effort cleanup
	}

	// Reset state
	c.mu.Lock()
	c.app = nil
	c.closers = nil
	c.mu.Unlock()

	// Reinitialize with fresh dependencies
	return c.Initialize(ctx)
}

// Close releases all resources
func (c *Container) Close() error {
	c.mu.Lock()
	defer c.mu.Unlock()

	var errs []error
	for _, closer := range c.closers {
		if err := closer(); err != nil {
			errs = append(errs, err)
		}
	}

	if len(errs) > 0 {
		return errs[0]
	}
	return nil
}

// Global container instance for gomobile
var (
	globalContainer *Container
	containerMu     sync.Mutex
)

// GetGlobalContainer returns the global container
func GetGlobalContainer() *Container {
	containerMu.Lock()
	defer containerMu.Unlock()
	return globalContainer
}

// InitGlobalContainer initializes the global container
func InitGlobalContainer(dbPath string) *Container {
	containerMu.Lock()
	defer containerMu.Unlock()
	globalContainer = NewContainer(dbPath)
	return globalContainer
}

// Closeable interface check for domain
var _ domain.Closeable = (*Container)(nil)
