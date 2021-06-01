part of 'provider.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  //The return type Future<SharedPreferences> isn't a 'SharedPreferences', as required by the closure's context
  //Code Reference: https://codewithandrea.com/videos/flutter-state-management-riverpod
  throw UnimplementedError();
});

final sharedUtilityProvider = Provider<SharedUtility>((ref) {
  final _sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SharedUtility(sharedPreferences: _sharedPrefs);
});

class SharedUtility {
  SharedUtility({
    this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  bool isDarkModeEnabled() {
    return sharedPreferences.getBool('isDarkModeEnabled') ?? false;
  }

  Future<bool> setDarkModeEnabled(bool value) async {
    return await sharedPreferences.setBool('isDarkModeEnabled', value);
  }
}