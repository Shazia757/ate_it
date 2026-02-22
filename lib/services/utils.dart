import 'dart:convert';

import 'package:ate_it/services/local_storage.dart';
import 'package:ate_it/views/auth/no_connection_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

bool checkValidations(String response) {
  if (response.contains('An error occured')) {
    return false;
  }
  return true;
}

checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none)) {
    Get.to(() => NoInternetScreen());
  }
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
