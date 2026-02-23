// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'RoomAI';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get gallery => 'Galeri';

  @override
  String get settings => 'Ayarlar';

  @override
  String get getStarted => 'Başla';

  @override
  String get next => 'İleri';

  @override
  String get skip => 'Atla';

  @override
  String get back => 'Geri';

  @override
  String get cancel => 'İptal';

  @override
  String get ok => 'Tamam';

  @override
  String get save => 'Kaydet';

  @override
  String get share => 'Paylaş';

  @override
  String get delete => 'Sil';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get close => 'Kapat';

  @override
  String get done => 'Bitti';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get error => 'Hata';

  @override
  String get success => 'Başarılı';

  @override
  String get onboarding1Title => 'AI ile Hayalindeki Odayı Tasarla';

  @override
  String get onboarding1Subtitle =>
      'Tek bir fotoğrafla herhangi bir odayı ideal alanınıza dönüştürün';

  @override
  String get onboarding2Title => 'Fotoğraf Çek, Stil Seç';

  @override
  String get onboarding2Subtitle =>
      '20\'den fazla profesyonel iç tasarım stili arasından seçim yapın';

  @override
  String get onboarding3Title => 'Saniyeler İçinde Profesyonel Sonuçlar';

  @override
  String get onboarding3Subtitle =>
      'Her oda, bahçe ve alan için AI destekli tasarımlar';

  @override
  String get freeDesignsBadge => '3 Ücretsiz Tasarım';

  @override
  String get greeting => 'Merhaba! Bugün ne tasarlayalım?';

  @override
  String designsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasarım hakkı kaldı',
      one: '1 tasarım hakkı kaldı',
      zero: 'Tasarım hakkı kalmadı',
    );
    return '$_temp0';
  }

  @override
  String get unlimited => 'Sınırsız';

  @override
  String get roomDesign => 'Oda Tasarımı';

  @override
  String get gardenDesign => 'Bahçe Tasarımı';

  @override
  String get roomDesignDesc => 'İç mekanlarınızı dönüştürün';

  @override
  String get gardenDesignDesc => 'Güzel dış mekan tasarımları oluşturun';

  @override
  String get designStyles => 'Tasarım Stilleri';

  @override
  String get roomTypes => 'Oda Tipleri';

  @override
  String get recentDesigns => 'Son Tasarımlar';

  @override
  String get seeAll => 'Tümünü Gör';

  @override
  String get noDesignsYet => 'Henüz tasarım yok';

  @override
  String get startFirstDesign => 'İlk AI tasarımınızı oluşturun!';

  @override
  String get unlockUnlimited => 'Sınırsız tasarımın kilidini aç';

  @override
  String get goPro => 'Pro\'ya Geç';

  @override
  String get selectStyle => 'Stil Seç';

  @override
  String get selectRoomType => 'Oda Tipi Seç';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get proStyle => 'PRO';

  @override
  String get upgradeToUnlock => 'Bu stili açmak için Pro\'ya yükseltin';

  @override
  String get styleModern => 'Modern';

  @override
  String get styleMinimalist => 'Minimalist';

  @override
  String get styleScandinavian => 'İskandinav';

  @override
  String get styleIndustrial => 'Endüstriyel';

  @override
  String get styleBohemian => 'Bohem';

  @override
  String get styleClassic => 'Klasik';

  @override
  String get styleJapanese => 'Japon';

  @override
  String get styleArtDeco => 'Art Deco';

  @override
  String get styleMidCentury => 'Yüzyıl Ortası';

  @override
  String get styleCoastal => 'Kıyı';

  @override
  String get styleRustic => 'Rustik';

  @override
  String get styleTropical => 'Tropikal';

  @override
  String get styleContemporary => 'Çağdaş';

  @override
  String get styleTraditional => 'Geleneksel';

  @override
  String get styleFarmhouse => 'Çiftlik Evi';

  @override
  String get roomLivingRoom => 'Salon';

  @override
  String get roomBedroom => 'Yatak Odası';

  @override
  String get roomKitchen => 'Mutfak';

  @override
  String get roomBathroom => 'Banyo';

  @override
  String get roomGarden => 'Bahçe';

  @override
  String get roomOffice => 'Ofis';

  @override
  String get roomKidsRoom => 'Çocuk Odası';

  @override
  String get roomDiningRoom => 'Yemek Odası';

  @override
  String get uploadPhoto => 'Fotoğraf Yükle';

  @override
  String get tapToUpload => 'Oda fotoğrafı yüklemek için dokunun';

  @override
  String get camera => 'Kamera';

  @override
  String get fromGallery => 'Galeri';

  @override
  String get changePhoto => 'Değiştir';

  @override
  String get tipsTitle => 'En iyi sonuçlar için ipuçları';

  @override
  String get tip1 => 'İyi aydınlatma kullanın';

  @override
  String get tip2 => 'Odanın tamamını çekin';

  @override
  String get tip3 => 'Kamerayı düz tutun';

  @override
  String get tip4 => 'Aşırı açılardan kaçının';

  @override
  String get customize => 'Özelleştir';

  @override
  String get addCustomInstructions => 'Ek talimatlar ekleyin (isteğe bağlı)...';

  @override
  String get suggestions => 'Öneriler';

  @override
  String get chipNaturalLight => 'Doğal ışık ekle';

  @override
  String get chipPlants => 'Bitkiler ekle';

  @override
  String get chipMinimalist => 'Minimalist mobilya';

  @override
  String get chipWarmTones => 'Sıcak tonlar';

  @override
  String get chipCoolTones => 'Soğuk tonlar';

  @override
  String get chipOpenSpace => 'Açık alan';

  @override
  String get chipCozy => 'Sıcak atmosfer';

  @override
  String get chipLargeWindows => 'Büyük pencereler';

  @override
  String get generateDesign => 'Tasarım Oluştur';

  @override
  String get skipCustomize => 'Atla';

  @override
  String get generatingTitle => 'Tasarımınız oluşturuluyor...';

  @override
  String get analyzingRoom => 'Oda düzeniniz analiz ediliyor...';

  @override
  String get identifyingElements => 'Mobilya ve öğeler belirleniyor...';

  @override
  String applyingStyle(String style) {
    return '$style tasarımı uygulanıyor...';
  }

  @override
  String get refiningDetails => 'Detaylar ve dokular iyileştiriliyor...';

  @override
  String get addingTouches => 'Son dokunuşlar ekleniyor...';

  @override
  String get almostReady => 'Neredeyse hazır...';

  @override
  String get designReady => 'Tasarımınız hazır!';

  @override
  String get usuallyTakes => 'Genellikle 15-25 saniye sürer';

  @override
  String get takingLonger => 'Normalden biraz uzun sürüyor ama buna değecek!';

  @override
  String get cancelGeneration => 'Emin misiniz? Tasarımınız oluşturuluyor.';

  @override
  String get yourDesign => 'Tasarımınız';

  @override
  String get favorite => 'Favori';

  @override
  String get regenerate => 'Yeniden Oluştur';

  @override
  String get download => 'İndir';

  @override
  String get designSaved => 'Tasarım galeriye kaydedildi';

  @override
  String get likeWhatYouSee =>
      'Beğendiniz mi? Sınırsız tasarım için Pro\'ya geçin';

  @override
  String get myDesigns => 'Tasarımlarım';

  @override
  String get all => 'Tümü';

  @override
  String get favorites => 'Favoriler';

  @override
  String get noDesignsInGallery => 'Henüz tasarım yok';

  @override
  String get createFirstDesign => 'İlk Tasarımınızı Oluşturun';

  @override
  String get deleteDesign => 'Tasarımı Sil';

  @override
  String get deleteDesignConfirm =>
      'Bu tasarımı silmek istediğinize emin misiniz?';

  @override
  String get unlockUnlimitedDesigns => 'Sınırsız Tasarımın Kilidini Açın';

  @override
  String get featureUnlimitedDesigns => 'Sınırsız oda tasarımı';

  @override
  String get featureAllStyles => '20\'den fazla premium stil';

  @override
  String get featureHDExport => 'HD kalitede dışa aktarma';

  @override
  String get featureNoWatermark => 'Filigran yok';

  @override
  String get featureCustomPrompt => 'Özel istemler ve bahçe tasarımı';

  @override
  String get monthlyPlan => 'Aylık';

  @override
  String get annualPlan => 'Yıllık';

  @override
  String get monthlyPrice => '₺149.99/ay';

  @override
  String get annualPrice => '₺899.99/yıl';

  @override
  String get save50 => '%50 TASARRUF';

  @override
  String get freeTrial => '3 gün ücretsiz deneme';

  @override
  String get startFreeTrial => 'Ücretsiz Denemeyi Başlat';

  @override
  String get cancelAnytime => 'İstediğiniz zaman iptal edin';

  @override
  String get restorePurchases => 'Satın Almaları Geri Yükle';

  @override
  String get termsOfService => 'Kullanım Şartları';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get perMonth => '/ay';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get account => 'Hesap';

  @override
  String get subscriptionStatus => 'Abonelik';

  @override
  String get free => 'Ücretsiz';

  @override
  String get pro => 'Pro';

  @override
  String get preferences => 'Tercihler';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Koyu';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get support => 'Destek';

  @override
  String get rateUs => 'Bizi Değerlendirin';

  @override
  String get contactUs => 'Bize Ulaşın';

  @override
  String get clearGallery => 'Galeriyi Temizle';

  @override
  String get clearGalleryConfirm =>
      'Bu işlem tüm kayıtlı tasarımları silecektir. Bu geri alınamaz.';

  @override
  String appVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get noInternetConnection => 'İnternet bağlantısı yok';

  @override
  String get somethingWentWrong => 'Bir şeyler yanlış gitti';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String get permissionDenied => 'İzin reddedildi';

  @override
  String get openSettings => 'Ayarları Aç';

  @override
  String get cameraPermissionRequired =>
      'Fotoğraf çekmek için kamera izni gereklidir';

  @override
  String get storagePermissionRequired =>
      'Tasarımları kaydetmek için depolama izni gereklidir';
}
