part of 'model.dart';

class UserDataSharedUtility {
  UserDataSharedUtility({
    this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  Future<bool> setUserDataJSON(String value) async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('userData', value);
  }

  Future<String> getUserDataJSON() async {
    return sharedPreferences.getString('userData');
  }
}