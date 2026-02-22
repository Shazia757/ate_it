import 'dart:convert';
import 'dart:developer';
import 'package:ate_it/model/auth_model.dart';
import 'package:ate_it/model/issue_model.dart';
import 'package:ate_it/model/order_model.dart';
import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/model/user_model.dart';
import 'package:ate_it/model/wallet_model.dart';
import 'package:ate_it/services/urls.dart';
import 'package:ate_it/services/utils.dart';
import 'package:http/http.dart' as http;

class ApiService {
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
    await Future.delayed(const Duration(seconds: 1));
    return true;
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

  // //------------------Locations---------------------------//
  // Future<List<StateModel>> getStates() async {
  //   try {
  //     final response = await http.get(Uri.parse(Urls.states));
  //     if (checkValidations(response.body)) {
  //       final json = jsonDecode(response.body);
  //       final List data = json['data'];
  //       return data.map((e) => StateModel.fromJson(e)).toList();
  //     }
  //     return [];
  //   } catch (e) {
  //     return [];
  //   }
  // }

  // Future<List<DistrictModel>> getDistricts(int stateId) async {
  //   try {
  //     final response = await http.get(Uri.parse(Urls.districts(stateId)));
  //     if (checkValidations(response.body)) {
  //       final json = jsonDecode(response.body);
  //       final List data = json['data'];
  //       return data.map((e) => DistrictModel.fromJson(e)).toList();
  //     }
  //     return [];
  //   } catch (e) {
  //     return [];
  //   }
  // }

  //------------------Get restaurants---------------------------//

  Future<RestaurantResponse?> getRestaurants() async {
    try {
      log("restaurent api working");
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
      checkConnectivity();
      log('Api error fetching restaurants: $e');
    }
    return null;
  }

  //------------------Get restaurant Menu---------------------------//

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
      checkConnectivity();
      log('Api error:$e');
    }
    return null;
  }

  //--------------------Create Order---------------------------//

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
    } catch (e) {
      checkConnectivity();
    }
    return null;
  }

  //--------------------Get Order---------------------------//

  Future<OrderResponse?> getOrders() async {
    try {
      log('Order function is working ');
      final response = await http
          .get(Uri.parse(Urls.orders), headers: generateHeader())
          .timeout(Duration(seconds: 60));
      if (checkValidations(response.body)) {
        final json = jsonDecode(response.body);
        return OrderResponse.fromJson(json);
      }
    } catch (e) {
      log('Order api error:$e');
      checkConnectivity();
    }
    return null;
  }

  Future<WalletResponse?> getWalletData() async {
    try {
      final response = await http
          .get(Uri.parse(Urls.balance), headers: generateHeader())
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return WalletResponse.fromJson(responseJson);
      } else {
        log('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      checkConnectivity();
    }
    return null;
  }

  Future<TopupResponse?> getTopupRequests() async {
    try {
      final response = await http
          .get(Uri.parse(Urls.sendTopupRequest), headers: generateHeader())
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return TopupResponse.fromJson(responseJson);
      } else {
        log('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      checkConnectivity();
    }
    return null;
  }

  Future<WalletResponse?> sendTopupRequest(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(Uri.parse(Urls.sendTopupRequest),
              headers: generateHeader(), body: jsonEncode(data))
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        return WalletResponse.fromJson(responseJson);
      } else {
        log('Failed to topup: ${response.body}');
      }
    } catch (e) {
      checkConnectivity();
    }
    return null;
  }

  //------------------Logout---------------------------//

  Future<LoginResponse?> logout() async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.logout),
            body: jsonEncode({}),
            headers: generateHeader(),
          )
          .timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(responseJson);
    } catch (e) {
      log('Api error during logout:$e');
      checkConnectivity();
    }
    return null;
  }

  //------------------Issues---------------------------//

  Future<GetIssueResponse?> getIssues() async {
    try {
      final response = await http
          .get(Uri.parse(Urls.issues), headers: generateHeader())
          .timeout(Duration(seconds: 60));

      if (checkValidations(response.body)) {
        final json = jsonDecode(response.body);
        return GetIssueResponse.fromJson(json);
      }
    } catch (e) {
      log('Api error fetching issues: $e');
      checkConnectivity();
    }
    return null;
  }

  Future<IssueResponse?> reportIssue(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(Uri.parse(Urls.issues),
              headers: generateHeader(), body: jsonEncode(data))
          .timeout(Duration(seconds: 60));
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      return IssueResponse.fromJson(responseJson);
    } catch (e) {
      log('Api error reporting issue: $e');
      checkConnectivity();
    }
    return null;
  }

  Future<bool> updateIssue(int id, Map<String, dynamic> data) async {
    try {
      final response = await http
          .patch(Uri.parse(Urls.issueDetail(id)),
              headers: generateHeader(), body: jsonEncode(data))
          .timeout(Duration(seconds: 60));

      return checkValidations(response.body);
    } catch (e) {
      log('Api error updating issue: $e');
      checkConnectivity();
      return false;
    }
  }

  Future<bool> deleteIssue(int id) async {
    try {
      final response = await http
          .delete(Uri.parse(Urls.issueDetail(id)), headers: generateHeader())
          .timeout(Duration(seconds: 60));

      return checkValidations(response.body);
    } catch (e) {
      log('Api error deleting issue: $e');
      checkConnectivity();
      return false;
    }
  }
}
