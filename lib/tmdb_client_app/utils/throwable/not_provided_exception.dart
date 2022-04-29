class NotProvidedException implements Exception {
  String cause;

  NotProvidedException(this.cause);
}
