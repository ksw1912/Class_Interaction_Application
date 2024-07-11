class JwtExpiredException implements Exception {
  final String message;
  JwtExpiredException(this.message);

  @override
  String toString() => 'JwtExpiredException: $message';
}
