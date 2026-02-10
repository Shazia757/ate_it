import 'dart:convert';
import 'package:ate_it/model/auth_model.dart';
import 'package:ate_it/model/location_model.dart';
import 'package:ate_it/model/order_model.dart';
import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/model/user_model.dart';
import 'package:ate_it/services/urls.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  final _box = GetStorage();

  // Helper validation
  bool checkValidations(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }
    return false;
  }

  //------------------Auth---------------------------//

  Future<LoginResponse?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Urls.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (checkValidations(response)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        // Check if there is a 'data' field and potentially a token?
        // For now, adhering to the provided docs structure.
        return LoginResponse.fromJson(responseJson);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(Urls.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (checkValidations(response)) {
        return true;
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
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

  //------------------Locations---------------------------//
  Future<List<StateModel>> getStates() async {
    try {
      final response = await http.get(Uri.parse(Urls.states));
      if (checkValidations(response)) {
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
      if (checkValidations(response)) {
        final json = jsonDecode(response.body);
        final List data = json['data'];
        return data.map((e) => DistrictModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  //------------------Customer---------------------------//

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse(Urls.restaurants));
      if (checkValidations(response)) {
        final json = jsonDecode(response.body);
        final List data = json['data'];
        return data.map((e) => Restaurant.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      // Return empty or throw
      return [];
    }
  }

  Future<List<FoodItem>> getRestaurantMenu(int id) async {
    try {
      final response = await http.get(Uri.parse(Urls.restaurantMenu(id)));
      if (checkValidations(response)) {
        final json = jsonDecode(response.body);
        final List data = json['data'];
        return data.map((e) => FoodItem.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<OrderModel?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(Uri.parse(Urls.orders),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(orderData));

      if (checkValidations(response)) {
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
    if (checkValidations(response)) {
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
