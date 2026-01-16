package domain

// RawSchoolData matches the JSON structure from the EDB file
// https://www.edb.gov.hk/attachment/en/student-parents/sch-info/sch-search/sch-location-info/SCH_LOC_EDB.json
type RawSchoolData struct {
	SchoolNo        int64   `json:"SCHOOL NO."`
	EnglishCategory string  `json:"ENGLISH CATEGORY"`
	ChineseCategory string  `json:"中文類別"`
	EnglishName     string  `json:"ENGLISH NAME"`
	ChineseName     string  `json:"中文名稱"`
	EnglishAddress  string  `json:"ENGLISH ADDRESS"`
	ChineseAddress  string  `json:"中文地址"`
	Longitude       float64 `json:"LONGITUDE"`
	Latitude        float64 `json:"LATITUDE"`
	DistrictEn      string  `json:"DISTRICT"`
	DistrictZh      string  `json:"分區"`
	FinanceTypeEn   string  `json:"FINANCE TYPE"`
	FinanceTypeZh   string  `json:"資助種類"`
	SchoolLevelEn   string  `json:"SCHOOL LEVEL"`
	SchoolLevelZh   string  `json:"學校類型"`
	StudentGenderEn string  `json:"STUDENTS GENDER"`
	StudentGenderZh string  `json:"就讀學生性別"`
	SessionEn       string  `json:"SESSION"`
	SessionZh       string  `json:"學校授課時間"`
	ReligionEn      string  `json:"RELIGION"`
	ReligionZh      string  `json:"宗教"`
	Telephone       string  `json:"TELEPHONE"`
	FaxNumber       string  `json:"FAX NUMBER"`
	Website         string  `json:"WEBSITE"`
}

// ToSchool converts RawSchoolData to domain.School
func (d *RawSchoolData) ToSchool() *School {
	return &School{
		ID:              d.SchoolNo,
		OriginalIDs:     []int64{d.SchoolNo},
		NameEn:          d.EnglishName,
		NameZh:          d.ChineseName,
		AddressEn:       d.EnglishAddress,
		AddressZh:       d.ChineseAddress,
		Latitude:        d.Latitude,
		Longitude:       d.Longitude,
		DistrictEn:      d.DistrictEn,
		DistrictZh:      d.DistrictZh,
		FinanceTypesEn:  []string{d.FinanceTypeEn},
		FinanceTypesZh:  []string{d.FinanceTypeZh},
		SchoolLevelEn:   d.SchoolLevelEn,
		SchoolLevelZh:   d.SchoolLevelZh,
		CategoryEn:      d.EnglishCategory,
		CategoryZh:      d.ChineseCategory,
		StudentGenderEn: d.StudentGenderEn,
		StudentGenderZh: d.StudentGenderZh,
		SessionsEn:      []string{d.SessionEn},
		SessionsZh:      []string{d.SessionZh},
		ReligionEn:      d.ReligionEn,
		ReligionZh:      d.ReligionZh,
		Telephone:       d.Telephone,
		FaxNumber:       d.FaxNumber,
		Website:         d.Website,
	}
}
