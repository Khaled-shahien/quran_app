class MediaException implements Exception {
  final String message;

  const MediaException(this.message);

  @override
  String toString() => message;
}

class QuotaExceededException extends MediaException {
  const QuotaExceededException(super.message);
}

class MissingApiKeyException extends MediaException {
  const MissingApiKeyException(super.message);
}
