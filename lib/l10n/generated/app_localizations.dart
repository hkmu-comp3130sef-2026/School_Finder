import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// The app title displayed in the app bar
  ///
  /// In en, this message translates to:
  /// **'School Finder'**
  String get appTitle;

  /// Bottom navigation label for favorites
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// Bottom navigation label for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation label for search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Theme mode setting label
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settingsThemeMode;

  /// Color seed setting label
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get settingsColorSeed;

  /// System theme mode option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// Light theme mode option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// Dark theme mode option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Traditional Chinese language option
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get languageChinese;

  /// Search bar placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search schools...'**
  String get searchHint;

  /// Advanced search page title
  ///
  /// In en, this message translates to:
  /// **'Advanced Search'**
  String get advancedSearchTitle;

  /// Name filter label
  ///
  /// In en, this message translates to:
  /// **'School Name'**
  String get filterName;

  /// Address filter label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get filterAddress;

  /// District filter label
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get filterDistrict;

  /// Finance type filter label
  ///
  /// In en, this message translates to:
  /// **'Finance Type'**
  String get filterFinanceType;

  /// No description provided for @filterSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get filterSession;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get buttonApply;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get buttonReset;

  /// Nearby schools section title
  ///
  /// In en, this message translates to:
  /// **'Nearby Schools'**
  String get nearbySchools;

  /// Favorite schools section title
  ///
  /// In en, this message translates to:
  /// **'Favorite Schools'**
  String get favoriteSchools;

  /// Search results section title
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// School details page title
  ///
  /// In en, this message translates to:
  /// **'School Details'**
  String get schoolDetailsTitle;

  /// Telephone label
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get labelTelephone;

  /// Fax label
  ///
  /// In en, this message translates to:
  /// **'Fax'**
  String get labelFax;

  /// Website label
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get labelWebsite;

  /// Address label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get labelAddress;

  /// District label
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get labelDistrict;

  /// Finance type label
  ///
  /// In en, this message translates to:
  /// **'Finance Type'**
  String get labelFinanceType;

  /// School level label
  ///
  /// In en, this message translates to:
  /// **'School Level'**
  String get labelSchoolLevel;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get labelCategory;

  /// Student gender label
  ///
  /// In en, this message translates to:
  /// **'Student Gender'**
  String get labelStudentGender;

  /// Session label
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get labelSession;

  /// Religion label
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get labelReligion;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;

  /// Location permission error message
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to show nearby schools.'**
  String get errorLocationPermission;

  /// Undo action label
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// Snackbar message when removing from favorites
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// Snackbar message when adding to favorites
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// Distance in meters
  ///
  /// In en, this message translates to:
  /// **'{distance} m'**
  String distanceMeters(int distance);

  /// Distance in kilometers
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String distanceKilometers(String distance);

  /// Message shown when no schools are near the user's location
  ///
  /// In en, this message translates to:
  /// **'No schools found nearby'**
  String get noSchoolsNearby;

  /// Message shown when the user has no favorite schools
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// Placeholder message on empty search page
  ///
  /// In en, this message translates to:
  /// **'Enter a keyword to search'**
  String get enterKeywordToSearch;

  /// Message shown when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// Default option in filter dropdowns meaning no filter applied
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAny;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
