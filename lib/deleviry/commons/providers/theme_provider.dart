import 'package:flutter/foundation.dart';
import 'package:souqexpress/utill/app_constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider_D with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  ThemeProvider_D({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = true;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences!.setBool(AppConstants.theme, _darkTheme);
    notifyListeners();
  }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences!.getBool(AppConstants.theme) ?? false;
    notifyListeners();
  }


}
