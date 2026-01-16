package domain

// School is the core domain entity
type School struct {
	ID              int64
	OriginalIDs     []int64 // IDs of all schools merged into this one
	NameEn          string
	NameZh          string
	AddressEn       string
	AddressZh       string
	Latitude        float64
	Longitude       float64
	DistrictEn      string
	DistrictZh      string
	FinanceTypesEn  []string
	FinanceTypesZh  []string
	SchoolLevelEn   string
	SchoolLevelZh   string
	CategoryEn      string
	CategoryZh      string
	StudentGenderEn string
	StudentGenderZh string
	SessionsEn      []string
	SessionsZh      []string
	ReligionEn      string
	ReligionZh      string
	Telephone       string
	FaxNumber       string
	Website         string
}

// SchoolWithDistance for nearby search results
type SchoolWithDistance struct {
	School   *School
	Distance float64
}

// FilterOptions for search filters
type FilterOptions struct {
	FinanceTypes []string
	Sessions     []string
	Districts    []string
}

// AdvancedSearchCriteria for advanced search
type AdvancedSearchCriteria struct {
	Name        string
	Address     string
	District    string
	FinanceType string
	Session     string
}

// UserSettings domain entity
type UserSettings struct {
	Language  string
	ThemeMode string
	ColorSeed string
}

// MapState domain entity
type MapState struct {
	CenterLatitude  float64
	CenterLongitude float64
	ZoomLevel       float64
}
