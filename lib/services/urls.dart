class Urls {
  static const String base = 'https://ate-it-backend.vercel.app/api/v1';

  // Auth
  static const String register = '$base/auth/auth/register/';
  static const String login = '$base/auth/auth/login/';
  static const String logout = '$base/auth/auth/logout/';
  static const String profile = '$base/auth/auth/profile/';

  // Location
  static const String states = '$base/auth/locations/states/';
  static String districts(int stateId) =>
      '$base/auth/locations/districts/$stateId/';

  // Customer
  static const String restaurants = '$base/customer/restaurants/';
  static String restaurantMenu(int id) =>
      '$base/customer/restaurants/$id/menu/';
  static const String orders = '$base/customer/orders/';
}
