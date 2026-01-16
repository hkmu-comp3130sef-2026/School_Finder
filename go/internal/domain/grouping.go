package domain

import (
	"fmt"
	"math"
	"sort"
)

// GroupSchoolsByLocation groups schools that have the same name and location.
// Key = NameEn + Latitude(4dp) + Longitude(4dp)
func GroupSchoolsByLocation(schools []*School) []*School {
	groups := make(map[string][]*School)

	for _, s := range schools {
		// Create a grouping key
		// 4 decimal places is roughly 11m precision, sufficient for separate buildings
		key := fmt.Sprintf("%s|%.4f|%.4f", s.NameEn, s.Latitude, s.Longitude)
		groups[key] = append(groups[key], s)
	}

	result := make([]*School, 0, len(groups))

	for _, group := range groups {
		if len(group) == 0 {
			continue
		}

		// Use the first school as the base
		primary := group[0]

		// If there's only one school, no merging needed
		if len(group) == 1 {
			result = append(result, primary)
			continue
		}

		// Merge multiple schools
		merged := *primary // Shallow copy
		merged.OriginalIDs = make([]int64, 0, len(group))
		merged.FinanceTypesEn = make([]string, 0)
		merged.FinanceTypesZh = make([]string, 0)
		merged.SessionsEn = make([]string, 0)
		merged.SessionsZh = make([]string, 0)

		// Sets to avoid duplicates
		seenFinanceEn := make(map[string]bool)
		seenFinanceZh := make(map[string]bool)
		seenSessionEn := make(map[string]bool)
		seenSessionZh := make(map[string]bool)

		for _, s := range group {
			merged.OriginalIDs = append(merged.OriginalIDs, s.ID)

			// Merge Finance Types
			for _, f := range s.FinanceTypesEn {
				if f != "" && !seenFinanceEn[f] {
					seenFinanceEn[f] = true
					merged.FinanceTypesEn = append(merged.FinanceTypesEn, f)
				}
			}
			for _, f := range s.FinanceTypesZh {
				if f != "" && !seenFinanceZh[f] {
					seenFinanceZh[f] = true
					merged.FinanceTypesZh = append(merged.FinanceTypesZh, f)
				}
			}

			// Merge Sessions
			for _, sess := range s.SessionsEn {
				if sess != "" && !seenSessionEn[sess] {
					seenSessionEn[sess] = true
					merged.SessionsEn = append(merged.SessionsEn, sess)
				}
			}
			for _, sess := range s.SessionsZh {
				if sess != "" && !seenSessionZh[sess] {
					seenSessionZh[sess] = true
					merged.SessionsZh = append(merged.SessionsZh, sess)
				}
			}
		}

		// Sort needed for consistent output
		sort.Strings(merged.FinanceTypesEn)
		sort.Strings(merged.FinanceTypesZh)
		sort.Strings(merged.SessionsEn)
		sort.Strings(merged.SessionsZh)

		result = append(result, &merged)
	}

	// Sort result by ID for determinism
	sort.Slice(result, func(i, j int) bool {
		return result[i].ID < result[j].ID
	})

	return result
}

// Round coordinates or use key logic helper if needed separately
func round(val float64) float64 {
	return math.Round(val*10000) / 10000
}
