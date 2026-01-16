package memdb

import (
	"context"
	"core/internal/domain"
	"core/internal/logger"
	"math"
	"sort"
	"strings"
	"sync"
)

// searchableSchool wraps domain.School with pre-calculated lowercase strings for fast search
type searchableSchool struct {
	*domain.School
	nameEnLower     string
	nameZhLower     string
	addressEnLower  string
	addressZhLower  string
	districtEnLower string
	districtZhLower string
}

// SchoolRepository provides in-memory storage for schools
type SchoolRepository struct {
	schools map[int64]*searchableSchool
	mu      sync.RWMutex
}

// NewSchoolRepository creates a new empty repository.
// Data should be loaded via SyncData from SQLite.
func NewSchoolRepository() *SchoolRepository {
	return &SchoolRepository{
		schools: make(map[int64]*searchableSchool),
	}
}

// calculateDistance using Haversine formula
func calculateDistance(lat1, lon1, lat2, lon2 float64) float64 {
	const R = 6371000 // Earth radius in meters
	dLat := (lat2 - lat1) * (math.Pi / 180.0)
	dLon := (lon2 - lon1) * (math.Pi / 180.0)

	a := math.Sin(dLat/2)*math.Sin(dLat/2) +
		math.Cos(lat1*(math.Pi/180.0))*math.Cos(lat2*(math.Pi/180.0))*
			math.Sin(dLon/2)*math.Sin(dLon/2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))
	return R * c
}

// SyncData replaces all school data atomically
func (r *SchoolRepository) SyncData(ctx context.Context, schools []*domain.School) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	newMap := make(map[int64]*searchableSchool)
	for _, s := range schools {
		newMap[s.ID] = &searchableSchool{
			School:          s,
			nameEnLower:     strings.ToLower(s.NameEn),
			nameZhLower:     strings.ToLower(s.NameZh),
			addressEnLower:  strings.ToLower(s.AddressEn),
			addressZhLower:  strings.ToLower(s.AddressZh),
			districtEnLower: strings.ToLower(s.DistrictEn),
			districtZhLower: strings.ToLower(s.DistrictZh),
		}
	}
	r.schools = newMap
	return nil
}

// GetNearby returns schools within range sorted by distance
// Uses bounding-box pre-filtering to reduce O(N) to O(M) complexity
func (r *SchoolRepository) GetNearby(ctx context.Context, lat, lng, rangeMeters float64) ([]*domain.SchoolWithDistance, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	// Calculate bounding box for pre-filtering
	// 1 degree latitude ≈ 111km, 1 degree longitude varies by latitude
	latDelta := rangeMeters / 111000.0
	lngDelta := rangeMeters / (111000.0 * math.Cos(lat*math.Pi/180.0))

	minLat := lat - latDelta
	maxLat := lat + latDelta
	minLng := lng - lngDelta
	maxLng := lng + lngDelta

	// Normalize longitudes and handle meridian crossing
	normalizeLng := func(l float64) float64 {
		for l > 180 {
			l -= 360
		}
		for l < -180 {
			l += 360
		}
		return l
	}
	minLng = normalizeLng(minLng)
	maxLng = normalizeLng(maxLng)

	isLngInRange := func(l float64) bool {
		if minLng <= maxLng {
			return l >= minLng && l <= maxLng
		}
		// Crosses 180/-180 meridian
		return l >= minLng || l <= maxLng
	}

	logger.Get().D("MemDB", "GetNearby: lat=%.6f lng=%.6f range=%.0f box=[%.6f, %.6f]x[%.6f, %.6f]", lat, lng, rangeMeters, minLat, maxLat, minLng, maxLng)

	var results []*domain.SchoolWithDistance

	for _, s := range r.schools {
		// Bounding-box pre-filter (fast rejection)
		if s.Latitude < minLat || s.Latitude > maxLat || !isLngInRange(s.Longitude) {
			continue
		}

		// Precise Haversine calculation only for candidates
		dist := calculateDistance(lat, lng, s.Latitude, s.Longitude)
		if dist <= rangeMeters {
			results = append(results, &domain.SchoolWithDistance{
				School:   s.School,
				Distance: dist,
			})
		}
	}

	// Sort by distance
	sort.Slice(results, func(i, j int) bool {
		return results[i].Distance < results[j].Distance
	})

	logger.Get().D("MemDB", "GetNearby: found %d schools", len(results))

	return results, nil
}

// GetById returns a school by ID
func (r *SchoolRepository) GetById(ctx context.Context, id int64) (*domain.School, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	if s, ok := r.schools[id]; ok {
		return s.School, nil
	}
	return nil, nil
}

// Search performs basic keyword search
func (r *SchoolRepository) Search(ctx context.Context, keyword string) ([]*domain.School, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	var results []*domain.School
	kw := strings.ToLower(keyword)

	for _, s := range r.schools {
		if strings.Contains(s.nameEnLower, kw) ||
			strings.Contains(s.nameZhLower, kw) ||
			strings.Contains(s.addressEnLower, kw) ||
			strings.Contains(s.addressZhLower, kw) {
			results = append(results, s.School)
		}
	}

	// Limit results to 50
	if len(results) > 50 {
		results = results[:50]
	}
	return results, nil
}

// AdvancedSearch performs filtered search
func (r *SchoolRepository) AdvancedSearch(ctx context.Context, criteria *domain.AdvancedSearchCriteria) ([]*domain.School, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	var results []*domain.School

	// Pre-compute lowercase versions for case-insensitive matching
	nameLower := strings.ToLower(criteria.Name)
	addressLower := strings.ToLower(criteria.Address)
	districtLower := strings.ToLower(criteria.District)

	for _, s := range r.schools {
		match := true

		if criteria.Name != "" {
			if !strings.Contains(s.nameEnLower, nameLower) &&
				!strings.Contains(s.nameZhLower, nameLower) {
				match = false
			}
		}
		if match && criteria.Address != "" {
			if !strings.Contains(s.addressEnLower, addressLower) &&
				!strings.Contains(s.addressZhLower, addressLower) {
				match = false
			}
		}
		if match && criteria.District != "" {
			if !strings.Contains(s.districtEnLower, districtLower) &&
				!strings.Contains(s.districtZhLower, districtLower) {
				match = false
			}
		}

		if match && criteria.FinanceType != "" {
			found := false
			for _, f := range s.FinanceTypesEn {
				if f == criteria.FinanceType {
					found = true
					break
				}
			}
			if !found {
				for _, f := range s.FinanceTypesZh {
					if f == criteria.FinanceType {
						found = true
						break
					}
				}
			}
			if !found {
				match = false
			}
		}
		if match && criteria.Session != "" {
			found := false
			for _, sess := range s.SessionsEn {
				if sess == criteria.Session {
					found = true
					break
				}
			}
			if !found {
				for _, sess := range s.SessionsZh {
					if sess == criteria.Session {
						found = true
						break
					}
				}
			}
			if !found {
				match = false
			}
		}

		if match {
			results = append(results, s.School)
		}
	}
	return results, nil
}

// GetFilterOptions returns available filter values based on language
func (r *SchoolRepository) GetFilterOptions(ctx context.Context, language string) (*domain.FilterOptions, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()

	financeTypes := make(map[string]bool)
	sessions := make(map[string]bool)
	districts := make(map[string]bool)

	isZh := language == "zh" || language == "zh_HK"

	for _, s := range r.schools {
		if isZh {
			for _, f := range s.FinanceTypesZh {
				if f != "" {
					financeTypes[f] = true
				}
			}
			for _, sess := range s.SessionsZh {
				if sess != "" {
					sessions[sess] = true
				}
			}
			if s.DistrictZh != "" {
				districts[s.DistrictZh] = true
			}
		} else {
			for _, f := range s.FinanceTypesEn {
				if f != "" {
					financeTypes[f] = true
				}
			}
			for _, sess := range s.SessionsEn {
				if sess != "" {
					sessions[sess] = true
				}
			}
			if s.DistrictEn != "" {
				districts[s.DistrictEn] = true
			}
		}
	}

	resp := &domain.FilterOptions{}
	for k := range financeTypes {
		resp.FinanceTypes = append(resp.FinanceTypes, k)
	}
	for k := range sessions {
		resp.Sessions = append(resp.Sessions, k)
	}
	for k := range districts {
		resp.Districts = append(resp.Districts, k)
	}

	sort.Strings(resp.FinanceTypes)
	sort.Strings(resp.Sessions)
	sort.Strings(resp.Districts)

	return resp, nil
}

// Compile-time interface check
var _ domain.SchoolRepository = (*SchoolRepository)(nil)
