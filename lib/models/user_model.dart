part of 'model.dart';

class UserDataSharedUtility {
  UserDataSharedUtility({
    this.sharedPreferences,
  });

  final SharedPreferences? sharedPreferences;

  Future<bool> setUserDataJSON(String value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('userData', value);
  }

  Future<bool> setUserToken(String value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('userToken', value);
  }

  Future<bool> setUserTokenExpiration(String value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('userTokenExpiration', value);
  }

  Future<String?> getUserDataJSON() async {
    return sharedPreferences!.getString('userData');
  }

  Future<String?> getUserToken(String value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('userToken');
  }

  Future<String?> getUserTokenExpiration(String value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('userTokenExpiration');
  }
}