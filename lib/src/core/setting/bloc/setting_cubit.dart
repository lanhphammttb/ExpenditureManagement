import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show Locale;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  int? language;
  bool isDark;

  SettingCubit({this.language, required this.isDark})
      : super(
    SettingChange(
      _getLocal(language),
      isDark,
    ),
  );

  static Locale _getLocal(int? lang) {
    String localeName;

    if (kIsWeb) {
      // Adjust the logic for web
      localeName = 'en'; // replace with your logic for web
    } else {
      // For other platforms, use the existing logic
      localeName =
      lang == null ? 'en' : (lang == 0 ? 'vi' : 'en');
    }

    return Locale(localeName);
  }

  void toVietnamese() {
    language = 0;
    emit(SettingChange(const Locale('vi'), isDark));
  }

  void toEnglish() {
    language = 1;
    emit(SettingChange(const Locale('en'), isDark));
  }

  void changeTheme() {
    Locale locale = _getLocal(language);
    isDark = !isDark;
    emit(SettingChange(locale, isDark));
  }
}
