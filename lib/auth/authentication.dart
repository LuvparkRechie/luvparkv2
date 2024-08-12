import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    late bool checkBiometrics;
    try {
      checkBiometrics = await auth.canCheckBiometrics;

      return checkBiometrics;
    } on PlatformException {
      checkBiometrics = false;

      return checkBiometrics;
    }
  }

  void setPasswordBiometric(String myPass) async {
    encryptedSharedPreferences.setString('akong_password', myPass);
  }

  Future<String> getPasswordBiometric() async {
    return encryptedSharedPreferences.getString('akong_password');
  }

  void clearPassword() {
    encryptedSharedPreferences.remove('akong_password');
  }

  Future<void> setUserData(data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', data);
  }

  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userData');
  }

  //SET LOGIN
  Future<void> setLogin(loginData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_login', loginData);
  }

  //RETRIEVE LOGIN
  Future<dynamic> getUserLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('auth_login')!);
  }

  //SET BRGY
  Future<void> setBrgy(loginData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('brgy_data', loginData);
  }

  //SET CITY
  Future<void> setCity(loginData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('city_data', loginData);
  }

  //SET PROVINCE
  Future<void> setProvince(loginData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('province_data', loginData);
  }

  //SET LOGIN
  Future<void> setProfilePic(loginData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_pic', loginData);
  }

  //GET USER ID
  Future<int> getUserId() async {
    final item = await Authentication().getUserData();
    int userId = jsonDecode(item!)["user_id"];
    return userId;
  }
}
