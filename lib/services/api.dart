import 'dart:convert';
import 'dart:developer';
import 'package:ate_it/model/auth_model.dart';
import 'package:ate_it/model/location_model.dart';
import 'package:ate_it/model/order_model.dart';
import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/model/user_model.dart';
import 'package:ate_it/services/local_storage.dart';
import 'package:ate_it/services/urls.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  // Helper validation
  bool checkValidations(String response) {
    if (response.contains('An error occured')) {
      return false;
    }
    return true;
  }

  Map<String, String> generateHeader() {
    final String credentials =
        '${LocalStorage().readUser().username}:${LocalStorage().readPass()}';
    final String encoded = base64Encode(utf8.encode(credentials));
    final String basicAuth = 'Basic $encoded';

    return {
      'Content-Type': 'application/json',
      "Authorization": basicAuth,
      "Credentials": credentials
    };
  }
  //------------------Auth---------------------------//

  Future<LoginResponse?> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.login),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "username": username,
              "password": password,
            }),
          )
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return LoginResponse.fromJson(responseJson);
      }
    } catch (e) {
      log('Api error during login:$e');
    }
    return null;
  }

  Future<LoginResponse?> register(Map<String, dynamic> data) async {
    final response = await http
        .post(Uri.parse(Urls.register),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data))
        .timeout(Duration(seconds: 60));

    if (checkValidations(response.body)) {
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(responseJson);
    } else {
      log('Failed to register: ${response.body}');
    }
    return null;
  }

  Future<bool> sendOtp(String mobile) async {
    // Mock
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<User?> getProfile() async {
    // TODO: Add auth headers
    return null;
  }

  Future<GeneralResponse?> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await http
          .patch(Uri.parse(Urls.profile),
              body: jsonEncode(data), headers: generateHeader())
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return GeneralResponse.fromJson(responseJson);
      }
    } catch (e) {
      log('Api error:$e');
    }
    return null;
  }

  //------------------Locations---------------------------//
  Future<List<StateModel>> getStates() async {
    try {
      final response = await http.get(Uri.parse(Urls.states));
      if (checkValidations(response.body)) {
        final json = jsonDecode(response.body);
        final List data = json['data'];
        return data.map((e) => StateModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<DistrictModel>> getDistricts(int stateId) async {
    try {
      final response = await http.get(Uri.parse(Urls.districts(stateId)));
      if (checkValidations(response.body)) {
        final json = jsonDecode(response.body);
        final List data = json['data'];
        return data.map((e) => DistrictModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  //------------------Get restaturants---------------------------//

  Future<RestaurantResponse?> getRestaurants() async {
    try {
      log("restaurent api workind");
      log(generateHeader().toString());
      final response = await http
          .get(Uri.parse(Urls.restaurants), headers: generateHeader())
          .timeout(Duration(seconds: 60));
      log(response.body);

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return RestaurantResponse.fromJson(responseJson);
      }
    } catch (e) {
      log('Api error fetching restaurants: $e');
    }
    return null;
  }

  Future<MenuResponse?> getRestaurantMenu(int id) async {
    try {
      log("restaurent menu api working");
      log(id.toString());

      final response = await http
          .get(Uri.parse(Urls.restaurantMenu(id)), headers: generateHeader())
          .timeout(Duration(seconds: 60));
      if (checkValidations(response.body)) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return MenuResponse.fromJson(json);
      }
    } catch (e) {
      log('Api error:$e');
    }
  }

  Future<OrderModel?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(Uri.parse(Urls.orders),
          headers: generateHeader(), body: jsonEncode(orderData));
      log(response.body);
      if (checkValidations(response.body)) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        return OrderModel(
            id: 0,
            orderId: data['order_id'],
            totalAmount: data['total_amount'],
            status: data['status'],
            restaurantName: null,
            createdAt: null);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<OrderModel>> getOrders() async {
    final response = await http.get(Uri.parse(Urls.orders));
    if (checkValidations(response.body)) {
      final json = jsonDecode(response.body);
      final List data = json['data'];
      return data.map((e) => OrderModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getWalletData() async {
    // Mock for now
    await Future.delayed(const Duration(seconds: 1));
    return {'balance': 0.0, 'transactions': [], 'topupRequests': []};
  }
}
