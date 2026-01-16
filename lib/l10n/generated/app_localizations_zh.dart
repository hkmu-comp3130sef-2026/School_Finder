// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'School Finder';

  @override
  String get navFavorites => '收藏';

  @override
  String get navHome => '首頁';

  @override
  String get navSearch => '搜尋';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsThemeMode => '主題模式';

  @override
  String get settingsColorSeed => '主題顏色';

  @override
  String get themeModeSystem => '跟隨系統';

  @override
  String get themeModeLight => '淺色模式';

  @override
  String get themeModeDark => '深色模式';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '繁體中文';

  @override
  String get searchHint => '搜尋學校...';

  @override
  String get advancedSearchTitle => '進階搜尋';

  @override
  String get filterName => '學校名稱';

  @override
  String get filterAddress => '地址';

  @override
  String get filterDistrict => '分區';

  @override
  String get filterFinanceType => '資助種類';

  @override
  String get filterSession => '學校授課時間';

  @override
  String get buttonApply => '套用';

  @override
  String get buttonReset => '重設';

  @override
  String get nearbySchools => '附近學校';

  @override
  String get favoriteSchools => '收藏學校';

  @override
  String get searchResults => '搜尋結果';

  @override
  String get schoolDetailsTitle => '學校詳情';

  @override
  String get labelTelephone => '電話';

  @override
  String get labelFax => '傳真';

  @override
  String get labelWebsite => '網站';

  @override
  String get labelAddress => '地址';

  @override
  String get labelDistrict => '分區';

  @override
  String get labelFinanceType => '資助種類';

  @override
  String get labelSchoolLevel => '學校類型';

  @override
  String get labelCategory => '類別';

  @override
  String get labelStudentGender => '學生性別';

  @override
  String get labelSession => '授課時間';

  @override
  String get labelReligion => '宗教';

  @override
  String get errorGeneric => '發生錯誤，請重試。';

  @override
  String get errorLocationPermission => '需要位置權限才能顯示附近學校。';

  @override
  String get actionUndo => '復原';

  @override
  String get removedFromFavorites => '已從收藏移除';

  @override
  String get addedToFavorites => '已加入收藏';

  @override
  String distanceMeters(int distance) {
    return '$distance 米';
  }

  @override
  String distanceKilometers(String distance) {
    return '$distance 公里';
  }

  @override
  String get noSchoolsNearby => '附近沒有找到學校';

  @override
  String get noFavoritesYet => '尚無收藏';

  @override
  String get enterKeywordToSearch => '輸入關鍵字搜尋';

  @override
  String get noResultsFound => '找不到結果';

  @override
  String get filterAny => '不限';
}
