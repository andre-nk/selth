import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/pages/pages.dart';
import 'package:instagram_clone/providers/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _appThemeState = watch(appThemeStateProvider);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context
          .read(appThemeProvider)
          .getAppThemedata(context, _appThemeState),
      home: RootApp(),
    );
  }
}