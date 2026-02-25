// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RoomAI';

  @override
  String get home => 'Home';

  @override
  String get gallery => 'Gallery';

  @override
  String get settings => 'Settings';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get share => 'Share';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Try Again';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get onboarding1Title => 'Design Your Dream Room with AI';

  @override
  String get onboarding1Subtitle =>
      'Transform any room into your ideal space with a single photo';

  @override
  String get onboarding2Title => 'Snap a Photo, Pick a Style';

  @override
  String get onboarding2Subtitle =>
      'Choose from 20+ professional interior design styles';

  @override
  String get onboarding3Title => 'Professional Results in Seconds';

  @override
  String get onboarding3Subtitle =>
      'AI-powered designs for every room, garden, and space';

  @override
  String get freeDesignsBadge => '3 Free Designs';

  @override
  String get greeting => 'Hello! What shall we design today?';

  @override
  String designsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count designs remaining',
      one: '1 design remaining',
      zero: 'No designs remaining',
    );
    return '$_temp0';
  }

  @override
  String get unlimited => 'Unlimited';

  @override
  String get roomDesign => 'Room Design';

  @override
  String get gardenDesign => 'Garden Design';

  @override
  String get roomDesignDesc => 'Transform your indoor spaces';

  @override
  String get gardenDesignDesc => 'Create beautiful outdoor designs';

  @override
  String get designStyles => 'Design Styles';

  @override
  String get roomTypes => 'Room Types';

  @override
  String get recentDesigns => 'Recent Designs';

  @override
  String get seeAll => 'See All';

  @override
  String get noDesignsYet => 'No designs yet';

  @override
  String get startFirstDesign => 'Create your first AI design!';

  @override
  String get unlockUnlimited => 'Unlock unlimited designs';

  @override
  String get goPro => 'Go Pro';

  @override
  String get selectStyle => 'Select Style';

  @override
  String get selectRoomType => 'Select Room Type';

  @override
  String get continueButton => 'Continue';

  @override
  String get proStyle => 'PRO';

  @override
  String get upgradeToUnlock => 'Upgrade to Pro to unlock this style';

  @override
  String get styleModern => 'Modern';

  @override
  String get styleMinimalist => 'Minimalist';

  @override
  String get styleScandinavian => 'Scandinavian';

  @override
  String get styleIndustrial => 'Industrial';

  @override
  String get styleBohemian => 'Bohemian';

  @override
  String get styleClassic => 'Classic';

  @override
  String get styleJapanese => 'Japanese';

  @override
  String get styleArtDeco => 'Art Deco';

  @override
  String get styleMidCentury => 'Mid-Century';

  @override
  String get styleCoastal => 'Coastal';

  @override
  String get styleRustic => 'Rustic';

  @override
  String get styleTropical => 'Tropical';

  @override
  String get styleContemporary => 'Contemporary';

  @override
  String get styleTraditional => 'Traditional';

  @override
  String get styleFarmhouse => 'Farmhouse';

  @override
  String get roomLivingRoom => 'Living Room';

  @override
  String get roomBedroom => 'Bedroom';

  @override
  String get roomKitchen => 'Kitchen';

  @override
  String get roomBathroom => 'Bathroom';

  @override
  String get roomGarden => 'Garden';

  @override
  String get roomOffice => 'Office';

  @override
  String get roomKidsRoom => 'Kids Room';

  @override
  String get roomDiningRoom => 'Dining Room';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get tapToUpload => 'Tap to upload your room photo';

  @override
  String get camera => 'Camera';

  @override
  String get fromGallery => 'Gallery';

  @override
  String get changePhoto => 'Change';

  @override
  String get tipsTitle => 'Tips for best results';

  @override
  String get tip1 => 'Use good lighting';

  @override
  String get tip2 => 'Capture the full room';

  @override
  String get tip3 => 'Keep the camera level';

  @override
  String get tip4 => 'Avoid extreme angles';

  @override
  String get customize => 'Customize';

  @override
  String get addCustomInstructions => 'Add custom instructions (optional)...';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get chipNaturalLight => 'Add natural light';

  @override
  String get chipPlants => 'Add plants';

  @override
  String get chipMinimalist => 'Minimalist furniture';

  @override
  String get chipWarmTones => 'Warm tones';

  @override
  String get chipCoolTones => 'Cool tones';

  @override
  String get chipOpenSpace => 'Open space';

  @override
  String get chipCozy => 'Cozy atmosphere';

  @override
  String get chipLargeWindows => 'Large windows';

  @override
  String get generateDesign => 'Generate Design';

  @override
  String get skipCustomize => 'Skip';

  @override
  String get generatingTitle => 'Creating your design...';

  @override
  String get analyzingRoom => 'Analyzing your room layout...';

  @override
  String get identifyingElements => 'Identifying furniture and elements...';

  @override
  String applyingStyle(String style) {
    return 'Applying $style design...';
  }

  @override
  String get refiningDetails => 'Refining details and textures...';

  @override
  String get addingTouches => 'Adding finishing touches...';

  @override
  String get almostReady => 'Almost ready...';

  @override
  String get designReady => 'Your design is ready!';

  @override
  String get usuallyTakes => 'Usually takes 15-25 seconds';

  @override
  String get takingLonger =>
      'Taking a bit longer than usual, but it will be worth it!';

  @override
  String get cancelGeneration => 'Are you sure? Your design is being created.';

  @override
  String get yourDesign => 'Your Design';

  @override
  String get favorite => 'Favorite';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get download => 'Download';

  @override
  String get designSaved => 'Design saved to gallery';

  @override
  String get likeWhatYouSee =>
      'Like what you see? Go Pro for unlimited designs';

  @override
  String get myDesigns => 'My Designs';

  @override
  String get all => 'All';

  @override
  String get favorites => 'Favorites';

  @override
  String get noDesignsInGallery => 'No designs yet';

  @override
  String get createFirstDesign => 'Create Your First Design';

  @override
  String get deleteDesign => 'Delete Design';

  @override
  String get deleteDesignConfirm =>
      'Are you sure you want to delete this design?';

  @override
  String get unlockUnlimitedDesigns => 'Unlock Unlimited Designs';

  @override
  String get featureUnlimitedDesigns => 'Unlimited room designs';

  @override
  String get featureAllStyles => 'All 20+ premium styles';

  @override
  String get featureHDExport => 'HD quality exports';

  @override
  String get featureNoWatermark => 'No watermarks';

  @override
  String get featureCustomPrompt => 'Custom prompts & garden design';

  @override
  String get monthlyPlan => 'Monthly';

  @override
  String get annualPlan => 'Annual';

  @override
  String get monthlyPrice => '\$4.99/month';

  @override
  String get annualPrice => '\$29.99/year';

  @override
  String get save50 => 'SAVE 50%';

  @override
  String get freeTrial => '3-day free trial';

  @override
  String get startFreeTrial => 'Start Free Trial';

  @override
  String get cancelAnytime => 'Cancel anytime';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get perMonth => '/month';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get subscriptionStatus => 'Subscription';

  @override
  String get free => 'Free';

  @override
  String get pro => 'Pro';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get notifications => 'Notifications';

  @override
  String get support => 'Support';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get clearGallery => 'Clear Gallery';

  @override
  String get clearGalleryConfirm =>
      'This will delete all saved designs. This cannot be undone.';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get cameraPermissionRequired =>
      'Camera permission is required to take photos';

  @override
  String get storagePermissionRequired =>
      'Storage permission is required to save designs';
}
