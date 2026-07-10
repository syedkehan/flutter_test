abstract class AppUrl {
  AppUrl._();

  static String? get _base => 'https://api.example.com';

  static String get _baseUrl => '$_base/api';

  static String get refreshToken => '$_baseUrl/auth/refresh';
  static String get login => '$_baseUrl/auth/login';
  static String get logout => '$_baseUrl/auth/logout';
  static String get signUp => '$_baseUrl/auth/register';

  static const String posts =
      'https://jsonplaceholder.typicode.com/posts';
}
 