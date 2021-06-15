part of 'provider.dart';

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) {
  SharedPreferences? sharedPreferencesInstance;

  SharedPreferences.getInstance().then((value){
    sharedPreferencesInstance = value;
  });

  return sharedPreferencesInstance;
});

final themeSharedUtilityProvider = Provider<ThemeSharedUtility>((ref) {
  final _sharedPrefs = ref.watch(sharedPreferencesProvider);
  return ThemeSharedUtility(sharedPreferences: _sharedPrefs!);
});

final userDataUtilityProvider = Provider<UserDataSharedUtility>((ref) {
  final _sharedPrefs = ref.watch(sharedPreferencesProvider);
  return UserDataSharedUtility(sharedPreferences: _sharedPrefs!);
});


