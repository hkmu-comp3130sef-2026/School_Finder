// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'School Finder';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsThemeMode => 'Theme Mode';

  @override
  String get settingsColorSeed => 'Accent Color';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '繁體中文';

  @override
  String get searchHint => 'Search schools...';

  @override
  String get advancedSearchTitle => 'Advanced Search';

  @override
  String get filterName => 'School Name';

  @override
  String get filterAddress => 'Address';

  @override
  String get filterDistrict => 'District';

  @override
  String get filterFinanceType => 'Finance Type';

  @override
  String get filterSession => 'Session';

  @override
  String get buttonApply => 'Apply';

  @override
  String get buttonReset => 'Reset';

  @override
  String get nearbySchools => 'Nearby Schools';

  @override
  String get favoriteSchools => 'Favorite Schools';

  @override
  String get searchResults => 'Search Results';

  @override
  String get schoolDetailsTitle => 'School Details';

  @override
  String get labelTelephone => 'Telephone';

  @override
  String get labelFax => 'Fax';

  @override
  String get labelWebsite => 'Website';

  @override
  String get labelAddress => 'Address';

  @override
  String get labelDistrict => 'District';

  @override
  String get labelFinanceType => 'Finance Type';

  @override
  String get labelSchoolLevel => 'School Level';

  @override
  String get labelCategory => 'Category';

  @override
  String get labelStudentGender => 'Student Gender';

  @override
  String get labelSession => 'Session';

  @override
  String get labelReligion => 'Religion';

  @override
  String get errorGeneric => 'An error occurred. Please try again.';

  @override
  String get errorLocationPermission =>
      'Location permission is required to show nearby schools.';

  @override
  String get actionUndo => 'Undo';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String distanceMeters(int distance) {
    return '$distance m';
  }

  @override
  String distanceKilometers(String distance) {
    return '$distance km';
  }

  @override
  String get noSchoolsNearby => 'No schools found nearby';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get enterKeywordToSearch => 'Enter a keyword to search';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get filterAny => 'Any';
}
