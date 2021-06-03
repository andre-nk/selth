part of "provider.dart";

final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

final appThemeStateProvider = StateNotifierProvider<AppThemeNotifier, bool>((ref) {
  final _isDarkModeEnabled = ref.read(themeSharedUtilityProvider).isDarkModeEnabled();
  return AppThemeNotifier(_isDarkModeEnabled);
});

