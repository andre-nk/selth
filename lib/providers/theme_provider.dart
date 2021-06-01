part of "provider.dart";

final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

class AppTheme {
  static ThemeData _lightThemeData = ThemeData(
    primaryColor: Colors.white, 
    accentColor: HexColor("000000"),
    scaffoldBackgroundColor: Colors.white, 
    textTheme: TextTheme(
      headline6: TextStyle(color: HexColor("000000"), fontSize: 20, fontWeight: FontWeight.bold),
      subtitle1: TextStyle(color: HexColor("000000"), fontSize: 16, fontWeight: FontWeight.normal),
      subtitle2: TextStyle(color: HexColor("000000"), fontSize: 16, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          color: HexColor("000000"),
        ),
        primary: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    )
  );

  static ThemeData _darkThemeData = ThemeData(
    primaryColor: HexColor("000000"),
    accentColor: Colors.white,
    scaffoldBackgroundColor: HexColor("000000"),
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      subtitle1: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
      subtitle2: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          color: Colors.white,
        ),
        primary: HexColor("000000"),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: HexColor("000000"),
    )
  );

  ThemeData getAppThemedata(BuildContext context, bool isDarkModeEnabled) {
    return isDarkModeEnabled ? _darkThemeData : _lightThemeData;
  }
}

final appThemeStateProvider = StateNotifierProvider<AppThemeNotifier, bool>((ref) {
  final _isDarkModeEnabled = ref.read(sharedUtilityProvider).isDarkModeEnabled();
  return AppThemeNotifier(_isDarkModeEnabled);
});

class AppThemeNotifier extends StateNotifier<bool> {
  
  AppThemeNotifier(this.defaultDarkModeValue) : super(defaultDarkModeValue);

  final bool defaultDarkModeValue;

  toggleAppTheme(BuildContext context) {
    final _isDarkModeEnabled = context.read(sharedUtilityProvider).isDarkModeEnabled();
    final _toggleValue = !_isDarkModeEnabled;

    context.read(sharedUtilityProvider)
    .setDarkModeEnabled(_toggleValue)
    .whenComplete(
      () => {
        state = _toggleValue,
      },
    );
  }
}