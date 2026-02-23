import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'RoomAI'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Design Your Dream Room with AI'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Transform any room into your ideal space with a single photo'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Snap a Photo, Pick a Style'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose from 20+ professional interior design styles'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Professional Results in Seconds'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered designs for every room, garden, and space'**
  String get onboarding3Subtitle;

  /// No description provided for @freeDesignsBadge.
  ///
  /// In en, this message translates to:
  /// **'3 Free Designs'**
  String get freeDesignsBadge;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello! What shall we design today?'**
  String get greeting;

  /// No description provided for @designsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No designs remaining} =1{1 design remaining} other{{count} designs remaining}}'**
  String designsRemaining(int count);

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @roomDesign.
  ///
  /// In en, this message translates to:
  /// **'Room Design'**
  String get roomDesign;

  /// No description provided for @gardenDesign.
  ///
  /// In en, this message translates to:
  /// **'Garden Design'**
  String get gardenDesign;

  /// No description provided for @roomDesignDesc.
  ///
  /// In en, this message translates to:
  /// **'Transform your indoor spaces'**
  String get roomDesignDesc;

  /// No description provided for @gardenDesignDesc.
  ///
  /// In en, this message translates to:
  /// **'Create beautiful outdoor designs'**
  String get gardenDesignDesc;

  /// No description provided for @designStyles.
  ///
  /// In en, this message translates to:
  /// **'Design Styles'**
  String get designStyles;

  /// No description provided for @roomTypes.
  ///
  /// In en, this message translates to:
  /// **'Room Types'**
  String get roomTypes;

  /// No description provided for @recentDesigns.
  ///
  /// In en, this message translates to:
  /// **'Recent Designs'**
  String get recentDesigns;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @noDesignsYet.
  ///
  /// In en, this message translates to:
  /// **'No designs yet'**
  String get noDesignsYet;

  /// No description provided for @startFirstDesign.
  ///
  /// In en, this message translates to:
  /// **'Create your first AI design!'**
  String get startFirstDesign;

  /// No description provided for @unlockUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited designs'**
  String get unlockUnlimited;

  /// No description provided for @goPro.
  ///
  /// In en, this message translates to:
  /// **'Go Pro'**
  String get goPro;

  /// No description provided for @selectStyle.
  ///
  /// In en, this message translates to:
  /// **'Select Style'**
  String get selectStyle;

  /// No description provided for @selectRoomType.
  ///
  /// In en, this message translates to:
  /// **'Select Room Type'**
  String get selectRoomType;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @proStyle.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proStyle;

  /// No description provided for @upgradeToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro to unlock this style'**
  String get upgradeToUnlock;

  /// No description provided for @styleModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get styleModern;

  /// No description provided for @styleMinimalist.
  ///
  /// In en, this message translates to:
  /// **'Minimalist'**
  String get styleMinimalist;

  /// No description provided for @styleScandinavian.
  ///
  /// In en, this message translates to:
  /// **'Scandinavian'**
  String get styleScandinavian;

  /// No description provided for @styleIndustrial.
  ///
  /// In en, this message translates to:
  /// **'Industrial'**
  String get styleIndustrial;

  /// No description provided for @styleBohemian.
  ///
  /// In en, this message translates to:
  /// **'Bohemian'**
  String get styleBohemian;

  /// No description provided for @styleClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get styleClassic;

  /// No description provided for @styleJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get styleJapanese;

  /// No description provided for @styleArtDeco.
  ///
  /// In en, this message translates to:
  /// **'Art Deco'**
  String get styleArtDeco;

  /// No description provided for @styleMidCentury.
  ///
  /// In en, this message translates to:
  /// **'Mid-Century'**
  String get styleMidCentury;

  /// No description provided for @styleCoastal.
  ///
  /// In en, this message translates to:
  /// **'Coastal'**
  String get styleCoastal;

  /// No description provided for @styleRustic.
  ///
  /// In en, this message translates to:
  /// **'Rustic'**
  String get styleRustic;

  /// No description provided for @styleTropical.
  ///
  /// In en, this message translates to:
  /// **'Tropical'**
  String get styleTropical;

  /// No description provided for @styleContemporary.
  ///
  /// In en, this message translates to:
  /// **'Contemporary'**
  String get styleContemporary;

  /// No description provided for @styleTraditional.
  ///
  /// In en, this message translates to:
  /// **'Traditional'**
  String get styleTraditional;

  /// No description provided for @styleFarmhouse.
  ///
  /// In en, this message translates to:
  /// **'Farmhouse'**
  String get styleFarmhouse;

  /// No description provided for @roomLivingRoom.
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get roomLivingRoom;

  /// No description provided for @roomBedroom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get roomBedroom;

  /// No description provided for @roomKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get roomKitchen;

  /// No description provided for @roomBathroom.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get roomBathroom;

  /// No description provided for @roomGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get roomGarden;

  /// No description provided for @roomOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get roomOffice;

  /// No description provided for @roomKidsRoom.
  ///
  /// In en, this message translates to:
  /// **'Kids Room'**
  String get roomKidsRoom;

  /// No description provided for @roomDiningRoom.
  ///
  /// In en, this message translates to:
  /// **'Dining Room'**
  String get roomDiningRoom;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload your room photo'**
  String get tapToUpload;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get fromGallery;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changePhoto;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips for best results'**
  String get tipsTitle;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Use good lighting'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Capture the full room'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Keep the camera level'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'Avoid extreme angles'**
  String get tip4;

  /// No description provided for @customize.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get customize;

  /// No description provided for @addCustomInstructions.
  ///
  /// In en, this message translates to:
  /// **'Add custom instructions (optional)...'**
  String get addCustomInstructions;

  /// No description provided for @suggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// No description provided for @chipNaturalLight.
  ///
  /// In en, this message translates to:
  /// **'Add natural light'**
  String get chipNaturalLight;

  /// No description provided for @chipPlants.
  ///
  /// In en, this message translates to:
  /// **'Add plants'**
  String get chipPlants;

  /// No description provided for @chipMinimalist.
  ///
  /// In en, this message translates to:
  /// **'Minimalist furniture'**
  String get chipMinimalist;

  /// No description provided for @chipWarmTones.
  ///
  /// In en, this message translates to:
  /// **'Warm tones'**
  String get chipWarmTones;

  /// No description provided for @chipCoolTones.
  ///
  /// In en, this message translates to:
  /// **'Cool tones'**
  String get chipCoolTones;

  /// No description provided for @chipOpenSpace.
  ///
  /// In en, this message translates to:
  /// **'Open space'**
  String get chipOpenSpace;

  /// No description provided for @chipCozy.
  ///
  /// In en, this message translates to:
  /// **'Cozy atmosphere'**
  String get chipCozy;

  /// No description provided for @chipLargeWindows.
  ///
  /// In en, this message translates to:
  /// **'Large windows'**
  String get chipLargeWindows;

  /// No description provided for @generateDesign.
  ///
  /// In en, this message translates to:
  /// **'Generate Design'**
  String get generateDesign;

  /// No description provided for @skipCustomize.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipCustomize;

  /// No description provided for @generatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating your design...'**
  String get generatingTitle;

  /// No description provided for @analyzingRoom.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your room layout...'**
  String get analyzingRoom;

  /// No description provided for @identifyingElements.
  ///
  /// In en, this message translates to:
  /// **'Identifying furniture and elements...'**
  String get identifyingElements;

  /// No description provided for @applyingStyle.
  ///
  /// In en, this message translates to:
  /// **'Applying {style} design...'**
  String applyingStyle(String style);

  /// No description provided for @refiningDetails.
  ///
  /// In en, this message translates to:
  /// **'Refining details and textures...'**
  String get refiningDetails;

  /// No description provided for @addingTouches.
  ///
  /// In en, this message translates to:
  /// **'Adding finishing touches...'**
  String get addingTouches;

  /// No description provided for @almostReady.
  ///
  /// In en, this message translates to:
  /// **'Almost ready...'**
  String get almostReady;

  /// No description provided for @designReady.
  ///
  /// In en, this message translates to:
  /// **'Your design is ready!'**
  String get designReady;

  /// No description provided for @usuallyTakes.
  ///
  /// In en, this message translates to:
  /// **'Usually takes 15-25 seconds'**
  String get usuallyTakes;

  /// No description provided for @takingLonger.
  ///
  /// In en, this message translates to:
  /// **'Taking a bit longer than usual, but it will be worth it!'**
  String get takingLonger;

  /// No description provided for @cancelGeneration.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? Your design is being created.'**
  String get cancelGeneration;

  /// No description provided for @yourDesign.
  ///
  /// In en, this message translates to:
  /// **'Your Design'**
  String get yourDesign;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @designSaved.
  ///
  /// In en, this message translates to:
  /// **'Design saved to gallery'**
  String get designSaved;

  /// No description provided for @likeWhatYouSee.
  ///
  /// In en, this message translates to:
  /// **'Like what you see? Go Pro for unlimited designs'**
  String get likeWhatYouSee;

  /// No description provided for @myDesigns.
  ///
  /// In en, this message translates to:
  /// **'My Designs'**
  String get myDesigns;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @noDesignsInGallery.
  ///
  /// In en, this message translates to:
  /// **'No designs yet'**
  String get noDesignsInGallery;

  /// No description provided for @createFirstDesign.
  ///
  /// In en, this message translates to:
  /// **'Create Your First Design'**
  String get createFirstDesign;

  /// No description provided for @deleteDesign.
  ///
  /// In en, this message translates to:
  /// **'Delete Design'**
  String get deleteDesign;

  /// No description provided for @deleteDesignConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this design?'**
  String get deleteDesignConfirm;

  /// No description provided for @unlockUnlimitedDesigns.
  ///
  /// In en, this message translates to:
  /// **'Unlock Unlimited Designs'**
  String get unlockUnlimitedDesigns;

  /// No description provided for @featureUnlimitedDesigns.
  ///
  /// In en, this message translates to:
  /// **'Unlimited room designs'**
  String get featureUnlimitedDesigns;

  /// No description provided for @featureAllStyles.
  ///
  /// In en, this message translates to:
  /// **'All 20+ premium styles'**
  String get featureAllStyles;

  /// No description provided for @featureHDExport.
  ///
  /// In en, this message translates to:
  /// **'HD quality exports'**
  String get featureHDExport;

  /// No description provided for @featureNoWatermark.
  ///
  /// In en, this message translates to:
  /// **'No watermarks'**
  String get featureNoWatermark;

  /// No description provided for @featureCustomPrompt.
  ///
  /// In en, this message translates to:
  /// **'Custom prompts & garden design'**
  String get featureCustomPrompt;

  /// No description provided for @monthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyPlan;

  /// No description provided for @annualPlan.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annualPlan;

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$4.99/month'**
  String get monthlyPrice;

  /// No description provided for @annualPrice.
  ///
  /// In en, this message translates to:
  /// **'\$29.99/year'**
  String get annualPrice;

  /// No description provided for @save50.
  ///
  /// In en, this message translates to:
  /// **'SAVE 50%'**
  String get save50;

  /// No description provided for @freeTrial.
  ///
  /// In en, this message translates to:
  /// **'3-day free trial'**
  String get freeTrial;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get startFreeTrial;

  /// No description provided for @cancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime'**
  String get cancelAnytime;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @subscriptionStatus.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionStatus;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get pro;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @clearGallery.
  ///
  /// In en, this message translates to:
  /// **'Clear Gallery'**
  String get clearGallery;

  /// No description provided for @clearGalleryConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will delete all saved designs. This cannot be undone.'**
  String get clearGalleryConfirm;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to take photos'**
  String get cameraPermissionRequired;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to save designs'**
  String get storagePermissionRequired;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
