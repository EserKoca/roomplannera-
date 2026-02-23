# 🏠 RoomAI - AI Oda Tasarım Uygulaması - Master Plan

## Proje Özeti
**Uygulama:** RoomAI - AI Interior Design & Room Planner
**Teknoloji:** Flutter + OpenAI (DALL-E 3 + GPT-4 Vision)
**Monetizasyon:** Freemium + Subscription ($4.99/ay veya $29.99/yıl)
**Dil:** Türkçe + İngilizce (i18n)
**Hedef:** App Store & Google Play - Premium kalitede AI oda tasarım uygulaması

---

## 🎨 Mimari Kararlar

### State Management: **Riverpod 2.0**
- Neden: Type-safe, compile-time hata yakalama, test edilebilir, modüler yapı
- BLoC'a göre daha az boilerplate, GetX'e göre daha güvenli

### Mimari: **Clean Architecture + Feature-First**
- Presentation → Domain → Data katmanları
- Her feature kendi klasöründe bağımsız

### Design System: **Custom Premium Design**
- Dark-mode ağırlıklı premium görünüm
- Glassmorphism + Gradient efektler
- Lottie animasyonlar

---

## 📁 Klasör Yapısı

```
lib/
├── main.dart
├── app.dart
├── l10n/                          # Localization
│   ├── app_en.arb
│   └── app_tr.arb
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   ├── app_assets.dart
│   │   └── api_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── dark_theme.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── api_interceptor.dart
│   │   └── api_exceptions.dart
│   ├── utils/
│   │   ├── image_utils.dart
│   │   ├── share_utils.dart
│   │   └── permission_utils.dart
│   └── widgets/
│       ├── gradient_button.dart
│       ├── glass_card.dart
│       ├── loading_overlay.dart
│       ├── before_after_slider.dart
│       └── cached_image.dart
├── features/
│   ├── onboarding/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── onboarding_screen.dart
│   │   │   └── widgets/
│   │   │       ├── onboarding_page.dart
│   │   │       └── onboarding_indicator.dart
│   │   └── providers/
│   │       └── onboarding_provider.dart
│   ├── auth/
│   │   ├── presentation/
│   │   │   └── screens/
│   │   │       └── splash_screen.dart
│   │   └── providers/
│   │       └── auth_provider.dart
│   ├── home/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── style_carousel.dart
│   │   │       ├── room_type_grid.dart
│   │   │       ├── recent_designs_section.dart
│   │   │       └── premium_banner.dart
│   │   └── providers/
│   │       └── home_provider.dart
│   ├── design/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── design_style.dart
│   │   │   │   ├── room_type.dart
│   │   │   │   ├── design_request.dart
│   │   │   │   └── design_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── design_repository.dart
│   │   │   └── services/
│   │   │       └── openai_service.dart
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── style_selection_screen.dart
│   │   │   │   ├── room_type_screen.dart
│   │   │   │   ├── photo_upload_screen.dart
│   │   │   │   ├── custom_prompt_screen.dart
│   │   │   │   ├── generating_screen.dart
│   │   │   │   └── result_screen.dart
│   │   │   └── widgets/
│   │   │       ├── style_card.dart
│   │   │       ├── room_type_card.dart
│   │   │       ├── upload_area.dart
│   │   │       ├── generation_progress.dart
│   │   │       └── result_actions.dart
│   │   └── providers/
│   │       ├── design_provider.dart
│   │       └── generation_provider.dart
│   ├── gallery/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── saved_design.dart
│   │   │   └── repositories/
│   │   │       └── gallery_repository.dart
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── gallery_screen.dart
│   │   │   │   └── design_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── gallery_grid.dart
│   │   │       └── design_card.dart
│   │   └── providers/
│   │       └── gallery_provider.dart
│   ├── subscription/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── subscription_plan.dart
│   │   │   ├── repositories/
│   │   │   │   └── subscription_repository.dart
│   │   │   └── services/
│   │   │       └── revenue_cat_service.dart
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── paywall_screen.dart
│   │   │   └── widgets/
│   │   │       ├── plan_card.dart
│   │   │       ├── feature_list.dart
│   │   │       └── trial_banner.dart
│   │   └── providers/
│   │       └── subscription_provider.dart
│   └── settings/
│       ├── presentation/
│       │   └── screens/
│       │       └── settings_screen.dart
│       └── providers/
│           └── settings_provider.dart
assets/
├── images/
│   ├── onboarding/
│   ├── styles/
│   ├── room_types/
│   └── placeholders/
├── icons/
├── lottie/
│   ├── generating.json
│   ├── success.json
│   └── premium.json
└── fonts/
    └── PlusJakartaSans/
```

---

## 🎨 Design System

### Renk Paleti (Premium Dark Theme)
```dart
// Primary Gradient - Premium Purple/Blue
primary: #6C5CE7        // Ana mor
primaryLight: #A29BFE    // Açık mor
primaryDark: #5A4FCF     // Koyu mor

// Accent - Warm Gold
accent: #FFEAA7          // Altın
accentDark: #FDCB6E      // Koyu altın

// Background
bgPrimary: #0D0D0D       // Ana arka plan (neredeyse siyah)
bgSecondary: #1A1A2E     // İkincil arka plan
bgTertiary: #16213E      // Üçüncül (kartlar)
bgCard: #1E1E3A          // Kart arka planı

// Surface (Glassmorphism)
surfaceGlass: rgba(255,255,255,0.05)
surfaceBorder: rgba(255,255,255,0.1)

// Text
textPrimary: #FFFFFF
textSecondary: #B0B0C3
textTertiary: #6C6C80

// Semantic
success: #00B894
error: #FF6B6B
warning: #FFEAA7

// Gradient Presets
premiumGradient: LinearGradient(#6C5CE7, #A29BFE)
goldGradient: LinearGradient(#FFEAA7, #FDCB6E)
darkGradient: LinearGradient(#0D0D0D, #1A1A2E)
```

### Typography - Plus Jakarta Sans
```dart
// Headlines
h1: 32px / Bold / -0.5 letter-spacing
h2: 24px / Bold / -0.3 letter-spacing
h3: 20px / SemiBold / -0.2 letter-spacing

// Body
bodyLarge: 16px / Regular / 0
bodyMedium: 14px / Regular / 0.1
bodySmall: 12px / Regular / 0.2

// Labels
labelLarge: 14px / SemiBold / 0.5 (uppercase)
labelMedium: 12px / Medium / 0.3
buttonText: 16px / Bold / 0.5
```

### Spacing System (8px base)
```dart
xs: 4px   sm: 8px   md: 16px   lg: 24px   xl: 32px   xxl: 48px
```

---

## 📱 Ekran Akışı (Screen Flow)

### 1. Splash Screen (2 saniye)
- Animated logo + premium gradient background
- Kullanıcı durumu kontrolü (ilk açılış / geri dönen)

### 2. Onboarding (3 sayfa - sadece ilk açılış)
- **Sayfa 1:** "AI ile Hayalindeki Odayı Tasarla" - Lottie animasyon
- **Sayfa 2:** "Fotoğraf Çek, Dönüştür" - Before/After demo
- **Sayfa 3:** "20+ Profesyonel Stil" - Stil carousel
- Alt kısım: "Başla" + "3 Ücretsiz Tasarım" badge

### 3. Home Screen (Ana Sayfa - Tab 1)
- **Header:** Logo + ayarlar ikonu + premium badge
- **Greeting:** "Merhaba! Bugün ne tasarlayalım?"
- **Quick Actions:** 2 büyük kart (Oda Tasarla / Bahçe Tasarla)
- **Tasarım Stilleri Carousel:** Horizontal scroll, görselli stil kartları
- **Oda Tipleri Grid:** 2x3 grid, ikonlu
- **Son Tasarımlar:** Son 3 tasarım küçük kartları
- **Premium Banner:** (free kullanıcılar için) "Sınırsız tasarım için Pro'ya geç"

### 4. Style Selection Screen
- Grid layout (2 sütun)
- Her stil kartında:
  - Örnek tasarım görseli (gradient overlay)
  - Stil adı
  - Premium badge (bazıları premium)
- Stiller: Modern, Minimalist, Scandinavian, Industrial, Bohemian, Classic, Japanese, Art Deco, Mid-Century, Coastal, Rustic, Tropical, Contemporary, Traditional, Farmhouse

### 5. Room Type Selection Screen
- Grid layout (2 sütun)
- Her kart: İkon + İsim + Gradient background
- Oda tipleri: Salon, Yatak Odası, Mutfak, Banyo, Bahçe/Dış Mekan, Ofis, Çocuk Odası, Yemek Odası

### 6. Photo Upload Screen
- Büyük upload alanı (dashed border, gradient)
- 2 seçenek: Kamera / Galeri
- Örnek fotoğraf gösterimi
- İpuçları: "İyi aydınlatma kullanın", "Odanın tamamını çekin"

### 7. Custom Prompt Screen (Opsiyonel)
- Seçilen stil ve oda tipi gösterimi
- Ek istek text alanı
- Önerilen promptlar (chip formatında):
  - "Doğal ışık ekle"
  - "Bitkiler ekle"
  - "Minimalist mobilya"
  - "Sıcak tonlar"

### 8. Generating Screen (AI İşleniyor)
- Seçilen fotoğraf blurred background
- Lottie animasyon (merkez)
- Progress bar + yüzde
- "AI tasarımınızı oluşturuyor..." mesajı
- İpuçları carousel (alt kısım)
- Tahmini süre: ~15-30 saniye

### 9. Result Screen
- **Before/After Slider** (tam ekran)
- Alt kısım: Action bar
  - ❤️ Favorilere ekle
  - 💾 Kaydet
  - 📤 Paylaş
  - 🔄 Yeniden oluştur
- Stil/oda bilgisi kartı
- "Beğendin mi? Pro'ya geç!" (free kullanıcılar)

### 10. Gallery Screen (Tab 2)
- Grid layout (2 sütun, masonry)
- Her kart: Before/After küçük resim + stil badge
- Filtre: Tüm / Stile göre / Oda tipine göre
- Boş state: "Henüz tasarım yok, hemen başla!"

### 11. Paywall Screen
- Premium features showcase
- Lottie premium animasyon
- Feature listesi (✓ işaretli)
- 2 plan kartı: Aylık ($4.99) / Yıllık ($29.99 - %50 indirim badge)
- "3 gün ücretsiz dene" CTA
- Restore purchases link
- Terms & Privacy links

### 12. Settings Screen (Tab 3)
- Profil bilgileri
- Subscription durumu
- Dil seçimi (TR/EN)
- Tema seçimi (gelecek: light mode)
- Bildirimler
- Gizlilik politikası
- Kullanım şartları
- Bize ulaşın
- Uygulama versiyonu
- Restore purchases

### Bottom Navigation (3 Tab)
- 🏠 Ana Sayfa
- 🖼️ Galeri
- ⚙️ Ayarlar

---

## 📦 Gerekli Paketler

```yaml
dependencies:
  # Core
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

  # UI
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  lottie: ^3.1.0
  shimmer: ^3.0.0
  flutter_staggered_grid_view: ^0.7.0
  cached_network_image: ^3.3.1

  # Image
  image_picker: ^1.0.7
  image_cropper: ^5.0.1
  photo_view: ^0.15.0

  # Network
  dio: ^5.4.1

  # Storage
  hive_flutter: ^1.1.0
  path_provider: ^2.1.2

  # Subscription
  purchases_flutter: ^6.30.0  # RevenueCat

  # Share
  share_plus: ^7.2.2

  # Permissions
  permission_handler: ^11.3.0

  # Utils
  uuid: ^4.3.3
  flutter_dotenv: ^5.1.0

dev_dependencies:
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.8
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.3
```

---

## 🔌 OpenAI API Entegrasyonu

### Akış:
1. Kullanıcı fotoğraf yükler
2. GPT-4 Vision ile fotoğraf analizi (oda tipi, mevcut mobilyalar, boyutlar)
3. Analiz + seçilen stil + custom prompt → DALL-E 3'e gönder
4. Sonuç görseli döner

### API Service Yapısı:
```dart
class OpenAIService {
  // 1. Analyze room photo with GPT-4 Vision
  Future<RoomAnalysis> analyzeRoom(File image);

  // 2. Generate redesigned room with DALL-E 3
  Future<String> generateDesign({
    required RoomAnalysis analysis,
    required DesignStyle style,
    required RoomType roomType,
    String? customPrompt,
  });
}
```

### Prompt Engineering:
```
"Professional interior design photo of a {roomType} in {style} style.
The room has {analysis.dimensions}. {analysis.existingFeatures}.
{customPrompt}.
Ultra-realistic, 4K quality, architectural photography,
natural lighting, award-winning interior design."
```

---

## 💰 Monetizasyon Stratejisi

### Free Tier:
- 3 tasarım hakkı (toplam)
- Temel 5 stil
- Watermark'lı paylaşım
- Reklam yok (kullanıcı deneyimi için)

### Pro Tier ($4.99/ay veya $29.99/yıl):
- Sınırsız tasarım
- 15+ premium stil
- Watermark'sız
- HD kalite çıktı
- Öncelikli işleme
- Custom prompt
- Bahçe/dış mekan tasarımı

### Revenue Optimization:
1. **Soft Paywall:** 3 ücretsiz tasarımdan sonra paywall
2. **Hard Paywall Triggers:** Premium stiller, custom prompt, HD çıktı
3. **FOMO:** "Bu hafta %50 indirim" banner
4. **Social Proof:** "50.000+ kullanıcı" badge
5. **Free Trial:** 3 gün ücretsiz deneme (yıllık plan)

---

## 🚀 Implementation Sırası (Fazlar)

### Faz 1: Temel Altyapı ✅ (Bu oturum)
- [ ] Flutter projesi oluştur
- [ ] Klasör yapısı kur
- [ ] Design system (renkler, typography, tema)
- [ ] Core widgets (GradientButton, GlassCard, vs.)
- [ ] Router yapısı
- [ ] Localization altyapısı (TR/EN)

### Faz 2: Onboarding & Ana Sayfa
- [ ] Splash screen
- [ ] Onboarding screens (3 sayfa)
- [ ] Home screen (tam UI)
- [ ] Bottom navigation
- [ ] Stil carousel widget
- [ ] Oda tipi grid widget

### Faz 3: Tasarım Akışı (Core Feature)
- [ ] Stil seçim ekranı
- [ ] Oda tipi seçim ekranı
- [ ] Fotoğraf yükleme ekranı
- [ ] Custom prompt ekranı
- [ ] Generating ekranı (Lottie animasyon)
- [ ] Sonuç ekranı (Before/After slider)

### Faz 4: OpenAI Entegrasyonu
- [ ] API client setup
- [ ] GPT-4 Vision entegrasyonu
- [ ] DALL-E 3 entegrasyonu
- [ ] Prompt engineering
- [ ] Hata yönetimi

### Faz 5: Galeri & Paylaşım
- [ ] Galeri ekranı
- [ ] Tasarım detay ekranı
- [ ] Kaydetme (Hive local storage)
- [ ] Paylaşım fonksiyonu

### Faz 6: Subscription & Paywall
- [ ] RevenueCat entegrasyonu
- [ ] Paywall ekranı
- [ ] Subscription yönetimi
- [ ] Free/Pro kontrolleri

### Faz 7: Settings & Polish
- [ ] Ayarlar ekranı
- [ ] Dil değiştirme
- [ ] Tema yönetimi
- [ ] App Store metadata
- [ ] Final test & optimization

---

## 📊 Data Models

```dart
// Design Style
class DesignStyle {
  String id, name, nameEn, nameTr;
  String imagePath;
  bool isPremium;
  String promptKeyword;
}

// Room Type
class RoomType {
  String id, name, nameEn, nameTr;
  String iconPath;
  String promptKeyword;
}

// Design Request
class DesignRequest {
  String id;
  DesignStyle style;
  RoomType roomType;
  File originalImage;
  String? customPrompt;
  DateTime createdAt;
}

// Design Result
class DesignResult {
  String id;
  DesignRequest request;
  String generatedImageUrl;
  String originalImagePath;
  bool isFavorite;
  DateTime createdAt;
}

// Subscription
class SubscriptionStatus {
  bool isPro;
  int freeDesignsRemaining;
  DateTime? expiresAt;
  String? planId;
}
```

---

## ✅ Başarı Kriterleri
- [ ] Tüm ekranlar pixel-perfect premium görünüm
- [ ] OpenAI API düzgün çalışıyor
- [ ] Before/After slider smooth
- [ ] Subscription flow sorunsuz
- [ ] TR/EN çeviri tam
- [ ] App Store'a yüklenmeye hazır
- [ ] 60fps performans
