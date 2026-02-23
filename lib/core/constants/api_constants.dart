abstract class ApiConstants {
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String chatCompletionsEndpoint = '/chat/completions';
  static const String imageGenerationEndpoint = '/images/generations';
  static const String gpt4VisionModel = 'gpt-4o';
  static const String dalle3Model = 'dall-e-3';
  static const int maxFreeDesigns = 3;
  static const Duration generationTimeout = Duration(seconds: 120);
}
