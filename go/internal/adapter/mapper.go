package adapter

import (
	"core/internal/domain"
	"core/pkg/pb"
)

// SchoolToProto converts domain School to protobuf
func SchoolToProto(s *domain.School) *pb.School {
	if s == nil {
		return nil
	}
	return &pb.School{
		Id:              s.ID,
		OriginalIds:     s.OriginalIDs,
		NameEn:          s.NameEn,
		NameZh:          s.NameZh,
		AddressEn:       s.AddressEn,
		AddressZh:       s.AddressZh,
		Latitude:        s.Latitude,
		Longitude:       s.Longitude,
		DistrictEn:      s.DistrictEn,
		DistrictZh:      s.DistrictZh,
		FinanceTypesEn:  s.FinanceTypesEn,
		FinanceTypesZh:  s.FinanceTypesZh,
		SchoolLevelEn:   s.SchoolLevelEn,
		SchoolLevelZh:   s.SchoolLevelZh,
		CategoryEn:      s.CategoryEn,
		CategoryZh:      s.CategoryZh,
		StudentGenderEn: s.StudentGenderEn,
		StudentGenderZh: s.StudentGenderZh,
		SessionsEn:      s.SessionsEn,
		SessionsZh:      s.SessionsZh,
		ReligionEn:      s.ReligionEn,
		ReligionZh:      s.ReligionZh,
		Telephone:       s.Telephone,
		FaxNumber:       s.FaxNumber,
		Website:         s.Website,
	}
}

// ProtoToSchool converts protobuf School to domain
func ProtoToSchool(s *pb.School) *domain.School {
	if s == nil {
		return nil
	}
	return &domain.School{
		ID:              s.Id,
		OriginalIDs:     s.OriginalIds,
		NameEn:          s.NameEn,
		NameZh:          s.NameZh,
		AddressEn:       s.AddressEn,
		AddressZh:       s.AddressZh,
		Latitude:        s.Latitude,
		Longitude:       s.Longitude,
		DistrictEn:      s.DistrictEn,
		DistrictZh:      s.DistrictZh,
		FinanceTypesEn:  s.FinanceTypesEn,
		FinanceTypesZh:  s.FinanceTypesZh,
		SchoolLevelEn:   s.SchoolLevelEn,
		SchoolLevelZh:   s.SchoolLevelZh,
		CategoryEn:      s.CategoryEn,
		CategoryZh:      s.CategoryZh,
		StudentGenderEn: s.StudentGenderEn,
		StudentGenderZh: s.StudentGenderZh,
		SessionsEn:      s.SessionsEn,
		SessionsZh:      s.SessionsZh,
		ReligionEn:      s.ReligionEn,
		ReligionZh:      s.ReligionZh,
		Telephone:       s.Telephone,
		FaxNumber:       s.FaxNumber,
		Website:         s.Website,
	}
}

// SchoolsToProto converts slice of domain Schools to protobuf
func SchoolsToProto(schools []*domain.School) []*pb.School {
	result := make([]*pb.School, 0, len(schools))
	for _, s := range schools {
		result = append(result, SchoolToProto(s))
	}
	return result
}

// MapStateToProto converts domain MapState to protobuf
func MapStateToProto(m *domain.MapState) *pb.MapState {
	if m == nil {
		return nil
	}
	return &pb.MapState{
		CenterLatitude:  m.CenterLatitude,
		CenterLongitude: m.CenterLongitude,
		ZoomLevel:       m.ZoomLevel,
	}
}

// ProtoToMapState converts protobuf MapState to domain
func ProtoToMapState(m *pb.MapState) *domain.MapState {
	if m == nil {
		return nil
	}
	return &domain.MapState{
		CenterLatitude:  m.CenterLatitude,
		CenterLongitude: m.CenterLongitude,
		ZoomLevel:       m.ZoomLevel,
	}
}

// UserSettingsToProto converts domain UserSettings to protobuf
func UserSettingsToProto(s *domain.UserSettings) *pb.UserSettings {
	if s == nil {
		return nil
	}
	return &pb.UserSettings{
		Language:  s.Language,
		ThemeMode: s.ThemeMode,
		ColorSeed: s.ColorSeed,
	}
}

// ProtoToUserSettings converts protobuf UserSettings to domain
func ProtoToUserSettings(s *pb.UserSettings) *domain.UserSettings {
	if s == nil {
		return nil
	}
	return &domain.UserSettings{
		Language:  s.Language,
		ThemeMode: s.ThemeMode,
		ColorSeed: s.ColorSeed,
	}
}

// ProtoToAdvancedSearchCriteria converts protobuf request to domain criteria
func ProtoToAdvancedSearchCriteria(req *pb.AdvancedSearchRequest) *domain.AdvancedSearchCriteria {
	if req == nil {
		return nil
	}
	return &domain.AdvancedSearchCriteria{
		Name:        req.Name,
		Address:     req.Address,
		District:    req.District,
		FinanceType: req.FinanceType,
		Session:     req.Session,
	}
}

// FilterOptionsToProto converts domain FilterOptions to protobuf
func FilterOptionsToProto(f *domain.FilterOptions) *pb.FilterOptionsResponse {
	if f == nil {
		return nil
	}
	return &pb.FilterOptionsResponse{
		FinanceTypes: f.FinanceTypes,
		Sessions:     f.Sessions,
		Districts:    f.Districts,
	}
}

// SchoolWithDistanceToProto converts domain SchoolWithDistance to protobuf DTO
func SchoolWithDistanceToProto(s *domain.SchoolWithDistance) *pb.RangeSearchResponseDTO {
	if s == nil {
		return nil
	}
	return &pb.RangeSearchResponseDTO{
		School:   SchoolToProto(s.School),
		Distance: s.Distance,
	}
}

// SchoolsWithDistanceToProto converts slice to protobuf
func SchoolsWithDistanceToProto(schools []*domain.SchoolWithDistance) []*pb.RangeSearchResponseDTO {
	result := make([]*pb.RangeSearchResponseDTO, 0, len(schools))
	for _, s := range schools {
		result = append(result, SchoolWithDistanceToProto(s))
	}
	return result
}
