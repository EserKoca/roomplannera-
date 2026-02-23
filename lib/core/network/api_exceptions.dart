class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class RateLimitException extends ApiException {
  const RateLimitException() : super('Rate limit exceeded. Please wait a moment.', 429);
}

class AuthException extends ApiException {
  const AuthException() : super('Invalid API key. Please check your settings.', 401);
}

class ServerException extends ApiException {
  const ServerException() : super('Server error. Please try again later.', 500);
}

class NetworkException extends ApiException {
  const NetworkException() : super('No internet connection. Please check your network.');
}

class TimeoutException extends ApiException {
  const TimeoutException() : super('Request timed out. Please try again.', 408);
}

enum GenerationStage { idle, analyzing, generating, downloading, saving, complete, error }

class GenerationProgress {
  final GenerationStage stage;
  final double progress;
  final String? errorMessage;
  final bool canRetry;

  const GenerationProgress({
    this.stage = GenerationStage.idle,
    this.progress = 0.0,
    this.errorMessage,
    this.canRetry = false,
  });

  GenerationProgress copyWith({
    GenerationStage? stage,
    double? progress,
    String? errorMessage,
    bool? canRetry,
  }) {
    return GenerationProgress(
      stage: stage ?? this.stage,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      canRetry: canRetry ?? this.canRetry,
    );
  }
}
