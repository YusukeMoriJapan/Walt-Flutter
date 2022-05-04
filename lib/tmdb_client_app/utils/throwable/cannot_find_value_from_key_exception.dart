class CannotFindValueFromKeyException implements Exception {
  String cause;

  CannotFindValueFromKeyException(this.cause);
}
