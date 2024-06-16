class AppUrl {
  AppUrl._();

  // base url
  static const String baseUrl = 'http://127.0.0.1:8080'; // For Android Emulator

  // receiveTimeout
  static const Duration receiveTimeout = Duration(milliseconds: 15000);

  // connectTimeout
  static const Duration connectionTimeout = Duration(milliseconds: 15000);
}
