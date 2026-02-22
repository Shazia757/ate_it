import 'dart:developer';

import 'package:ate_it/model/user_model.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final _box = GetStorage();

  writeUser(User user) {
    try {
      _box.write('user', user.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  User readUser() {
    try {
      final data = _box.read('user');
      return User.fromJson(data);
    } catch (e) {
      log(e.toString());
    }
    return User();
  }

  writePassword(String pass) {
    try {
      _box.write('password', pass);
    } catch (e) {
      log(e.toString());
    }
  }

  String readPass() {
    try {
      final password = _box.read('password');
      return password;
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  clearAll() {
    _box.erase();
  }
}
