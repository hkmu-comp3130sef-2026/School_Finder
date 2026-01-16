package sqlite

import (
	"context"
	"core/internal/domain"
	"database/sql"
	"encoding/json"
	"fmt"

	_ "github.com/mattn/go-sqlite3"
)

// SQLiteRepository implements persistence for favorites, settings, and schools
type SQLiteRepository struct {
	db *sql.DB
}

// NewSQLiteRepository creates a new SQLite repository
func NewSQLiteRepository(dbPath string) (*SQLiteRepository, error) {
	db, err := sql.Open("sqlite3", dbPath)
	if err != nil {
		return nil, err
	}

	// Create tables
	if _, err := db.Exec(`
		CREATE TABLE IF NOT EXISTS user_favorites (
			school_id INTEGER PRIMARY KEY,
			added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		);
		CREATE TABLE IF NOT EXISTS key_value_store (
			key TEXT PRIMARY KEY,
			value BLOB
		);
		-- Raw schools from source
		CREATE TABLE IF NOT EXISTS persistence_schools (
			school_id INTEGER PRIMARY KEY,
			original_ids TEXT,
			name_en TEXT,
			name_zh TEXT,
			address_en TEXT,
			address_zh TEXT,
			latitude REAL,
			longitude REAL,
			district_en TEXT,
			district_zh TEXT,
			finance_type_en TEXT,
			finance_type_zh TEXT,
			school_level_en TEXT,
			school_level_zh TEXT,
			category_en TEXT,
			category_zh TEXT,
			student_gender_en TEXT,
			student_gender_zh TEXT,
			session_en TEXT,
			session_zh TEXT,
			religion_en TEXT,
			religion_zh TEXT,
			telephone TEXT,
			fax_number TEXT,
			website TEXT
		);
		-- Grouped schools (merged pins)
		CREATE TABLE IF NOT EXISTS grouped_schools (
			school_id INTEGER PRIMARY KEY,
			original_ids TEXT,
			name_en TEXT,
			name_zh TEXT,
			address_en TEXT,
			address_zh TEXT,
			latitude REAL,
			longitude REAL,
			district_en TEXT,
			district_zh TEXT,
			finance_type_en TEXT,
			finance_type_zh TEXT,
			school_level_en TEXT,
			school_level_zh TEXT,
			category_en TEXT,
			category_zh TEXT,
			student_gender_en TEXT,
			student_gender_zh TEXT,
			session_en TEXT,
			session_zh TEXT,
			religion_en TEXT,
			religion_zh TEXT,
			telephone TEXT,
			fax_number TEXT,
			website TEXT
		);
		CREATE INDEX IF NOT EXISTS idx_schools_name_en ON persistence_schools(name_en);
		CREATE INDEX IF NOT EXISTS idx_grouped_schools_name_en ON grouped_schools(name_en);
		CREATE INDEX IF NOT EXISTS idx_grouped_schools_coords ON grouped_schools(latitude, longitude);
	`); err != nil {
		return nil, err
	}

	return &SQLiteRepository{db: db}, nil
}

// SaveSchools persists raw schools to SQLite
func (r *SQLiteRepository) SaveSchools(ctx context.Context, schools []*domain.School) error {
	return r.saveSchoolsToTable(ctx, schools, "persistence_schools")
}

// SaveGroupedSchools persists grouped schools to SQLite
func (r *SQLiteRepository) SaveGroupedSchools(ctx context.Context, schools []*domain.School) error {
	return r.saveSchoolsToTable(ctx, schools, "grouped_schools")
}

func (r *SQLiteRepository) saveSchoolsToTable(ctx context.Context, schools []*domain.School, tableName string) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// Clear existing data
	if _, err := tx.ExecContext(ctx, fmt.Sprintf("DELETE FROM %s", tableName)); err != nil {
		return err
	}

	query := fmt.Sprintf(`INSERT INTO %s (
		school_id, name_en, name_zh, address_en, address_zh,
		latitude, longitude, district_en, district_zh,
		finance_type_en, finance_type_zh, school_level_en, school_level_zh,
		category_en, category_zh, student_gender_en, student_gender_zh,
		session_en, session_zh, religion_en, religion_zh,
		telephone, fax_number, website, original_ids
	) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`, tableName)

	stmt, err := tx.PrepareContext(ctx, query)
	if err != nil {
		return err
	}
	defer stmt.Close()

	for _, s := range schools {
		ftEn, _ := json.Marshal(s.FinanceTypesEn)
		ftZh, _ := json.Marshal(s.FinanceTypesZh)
		sessEn, _ := json.Marshal(s.SessionsEn)
		sessZh, _ := json.Marshal(s.SessionsZh)
		origIDs, _ := json.Marshal(s.OriginalIDs)

		if _, err := stmt.ExecContext(ctx, s.ID,
			s.NameEn, s.NameZh, s.AddressEn, s.AddressZh,
			s.Latitude, s.Longitude, s.DistrictEn, s.DistrictZh,
			string(ftEn), string(ftZh), s.SchoolLevelEn, s.SchoolLevelZh,
			s.CategoryEn, s.CategoryZh, s.StudentGenderEn, s.StudentGenderZh,
			string(sessEn), string(sessZh), s.ReligionEn, s.ReligionZh,
			s.Telephone, s.FaxNumber, s.Website, string(origIDs),
		); err != nil {
			return err
		}
	}

	return tx.Commit()
}

// LoadSchools loads raw schools from SQLite
func (r *SQLiteRepository) LoadSchools(ctx context.Context) ([]*domain.School, error) {
	return r.loadSchoolsFromTable(ctx, "persistence_schools")
}

// LoadGroupedSchools loads grouped schools from SQLite
func (r *SQLiteRepository) LoadGroupedSchools(ctx context.Context) ([]*domain.School, error) {
	return r.loadSchoolsFromTable(ctx, "grouped_schools")
}

func (r *SQLiteRepository) loadSchoolsFromTable(ctx context.Context, tableName string) ([]*domain.School, error) {
	query := fmt.Sprintf(`SELECT 
		school_id, name_en, name_zh, address_en, address_zh,
		latitude, longitude, district_en, district_zh,
		finance_type_en, finance_type_zh, school_level_en, school_level_zh,
		category_en, category_zh, student_gender_en, student_gender_zh,
		session_en, session_zh, religion_en, religion_zh,
		telephone, fax_number, website, IFNULL(original_ids, '[]')
		FROM %s`, tableName)

	rows, err := r.db.QueryContext(ctx, query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var schools []*domain.School
	for rows.Next() {
		s := &domain.School{}
		var ftEn, ftZh, sessEn, sessZh, origIDs string

		if err := rows.Scan(
			&s.ID, &s.NameEn, &s.NameZh, &s.AddressEn, &s.AddressZh,
			&s.Latitude, &s.Longitude, &s.DistrictEn, &s.DistrictZh,
			&ftEn, &ftZh, &s.SchoolLevelEn, &s.SchoolLevelZh,
			&s.CategoryEn, &s.CategoryZh, &s.StudentGenderEn, &s.StudentGenderZh,
			&sessEn, &sessZh, &s.ReligionEn, &s.ReligionZh,
			&s.Telephone, &s.FaxNumber, &s.Website, &origIDs,
		); err != nil {
			continue
		}

		_ = json.Unmarshal([]byte(ftEn), &s.FinanceTypesEn)
		_ = json.Unmarshal([]byte(ftZh), &s.FinanceTypesZh)
		_ = json.Unmarshal([]byte(sessEn), &s.SessionsEn)
		_ = json.Unmarshal([]byte(sessZh), &s.SessionsZh)
		_ = json.Unmarshal([]byte(origIDs), &s.OriginalIDs)

		schools = append(schools, s)
	}
	return schools, nil
}

// AdvancedSearch searches the grouped schools table normally (as that is what is effectively active)
// Or should it search grouped? Logic suggests we usually want to search what we display.
func (r *SQLiteRepository) AdvancedSearch(ctx context.Context, criteria *domain.AdvancedSearchCriteria) ([]*domain.School, error) {
	// Search on grouped_schools table for consistency with display
	query := `SELECT 
		school_id, name_en, name_zh, address_en, address_zh,
		latitude, longitude, district_en, district_zh,
		finance_type_en, finance_type_zh, school_level_en, school_level_zh,
		category_en, category_zh, student_gender_en, student_gender_zh,
		session_en, session_zh, religion_en, religion_zh,
		telephone, fax_number, website, IFNULL(original_ids, '[]')
		FROM grouped_schools WHERE 1=1`

	var args []interface{}

	if criteria.Name != "" {
		query += " AND (name_en LIKE ? COLLATE NOCASE OR name_zh LIKE ? COLLATE NOCASE)"
		pattern := "%" + criteria.Name + "%"
		args = append(args, pattern, pattern)
	}
	if criteria.Address != "" {
		query += " AND (address_en LIKE ? COLLATE NOCASE OR address_zh LIKE ? COLLATE NOCASE)"
		pattern := "%" + criteria.Address + "%"
		args = append(args, pattern, pattern)
	}
	if criteria.District != "" {
		query += " AND (district_en LIKE ? COLLATE NOCASE OR district_zh LIKE ? COLLATE NOCASE)"
		pattern := "%" + criteria.District + "%"
		args = append(args, pattern, pattern)
	}

	if criteria.FinanceType != "" {
		query += " AND (finance_type_en LIKE ? OR finance_type_zh LIKE ?)"
		pattern := "%" + criteria.FinanceType + "%"
		args = append(args, pattern, pattern)
	}
	if criteria.Session != "" {
		query += " AND (session_en LIKE ? OR session_zh LIKE ?)"
		pattern := "%" + criteria.Session + "%"
		args = append(args, pattern, pattern)
	}

	rows, err := r.db.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var schools []*domain.School
	for rows.Next() {
		s := &domain.School{}
		var ftEn, ftZh, sessEn, sessZh, origIDs string

		if err := rows.Scan(
			&s.ID, &s.NameEn, &s.NameZh, &s.AddressEn, &s.AddressZh,
			&s.Latitude, &s.Longitude, &s.DistrictEn, &s.DistrictZh,
			&ftEn, &ftZh, &s.SchoolLevelEn, &s.SchoolLevelZh,
			&s.CategoryEn, &s.CategoryZh, &s.StudentGenderEn, &s.StudentGenderZh,
			&sessEn, &sessZh, &s.ReligionEn, &s.ReligionZh,
			&s.Telephone, &s.FaxNumber, &s.Website, &origIDs,
		); err != nil {
			continue
		}

		_ = json.Unmarshal([]byte(ftEn), &s.FinanceTypesEn)
		_ = json.Unmarshal([]byte(ftZh), &s.FinanceTypesZh)
		_ = json.Unmarshal([]byte(sessEn), &s.SessionsEn)
		_ = json.Unmarshal([]byte(sessZh), &s.SessionsZh)
		_ = json.Unmarshal([]byte(origIDs), &s.OriginalIDs)

		schools = append(schools, s)
	}
	return schools, nil
}

// FavoriteRepository implementation

// GetFavoriteIDs returns all favorite school IDs
func (r *SQLiteRepository) GetFavoriteIDs(ctx context.Context) ([]int64, error) {
	rows, err := r.db.QueryContext(ctx, "SELECT school_id FROM user_favorites ORDER BY added_at DESC")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var ids []int64
	for rows.Next() {
		var id int64
		if err := rows.Scan(&id); err != nil {
			return nil, err
		}
		ids = append(ids, id)
	}
	return ids, nil
}

// AddFavorite adds a school to favorites
func (r *SQLiteRepository) AddFavorite(ctx context.Context, schoolID int64) error {
	_, err := r.db.ExecContext(ctx, "INSERT OR IGNORE INTO user_favorites (school_id) VALUES (?)", schoolID)
	return err
}

// RemoveFavorite removes a school from favorites
func (r *SQLiteRepository) RemoveFavorite(ctx context.Context, schoolID int64) error {
	_, err := r.db.ExecContext(ctx, "DELETE FROM user_favorites WHERE school_id = ?", schoolID)
	return err
}

// SettingsRepository implementation

func (r *SQLiteRepository) getJSON(ctx context.Context, key string, v interface{}) error {
	var val []byte
	err := r.db.QueryRowContext(ctx, "SELECT value FROM key_value_store WHERE key = ?", key).Scan(&val)
	if err == sql.ErrNoRows {
		return nil // Empty, use defaults
	}
	if err != nil {
		return err
	}
	return json.Unmarshal(val, v)
}

func (r *SQLiteRepository) saveJSON(ctx context.Context, key string, v interface{}) error {
	val, err := json.Marshal(v)
	if err != nil {
		return err
	}
	_, err = r.db.ExecContext(ctx, "INSERT OR REPLACE INTO key_value_store (key, value) VALUES (?, ?)", key, val)
	return err
}

// GetSettings returns user settings with defaults
func (r *SQLiteRepository) GetSettings(ctx context.Context) (*domain.UserSettings, error) {
	s := &domain.UserSettings{}
	err := r.getJSON(ctx, "user_settings", s)

	// Set defaults if empty
	if s.Language == "" {
		s.Language = "en"
	}
	if s.ThemeMode == "" {
		s.ThemeMode = "system"
	}
	if s.ColorSeed == "" {
		s.ColorSeed = "blue"
	}
	return s, err
}

// UpdateSettings saves user settings
func (r *SQLiteRepository) UpdateSettings(ctx context.Context, settings *domain.UserSettings) error {
	return r.saveJSON(ctx, "user_settings", settings)
}

// GetMapState returns map state with defaults
func (r *SQLiteRepository) GetMapState(ctx context.Context) (*domain.MapState, error) {
	s := &domain.MapState{}
	err := r.getJSON(ctx, "map_state", s)

	if s.ZoomLevel == 0 { // Default
		s.CenterLatitude = 22.3193
		s.CenterLongitude = 114.1694
		s.ZoomLevel = 13.0
	}
	return s, err
}

// SaveMapState saves map state
func (r *SQLiteRepository) SaveMapState(ctx context.Context, state *domain.MapState) error {
	return r.saveJSON(ctx, "map_state", state)
}

// Close closes the database connection
func (r *SQLiteRepository) Close() error {
	return r.db.Close()
}

// Compile-time interface checks
var _ domain.FavoriteRepository = (*SQLiteRepository)(nil)
var _ domain.SettingsRepository = (*SQLiteRepository)(nil)
var _ domain.SchoolPersistenceRepository = (*SQLiteRepository)(nil)
var _ domain.Closeable = (*SQLiteRepository)(nil)
