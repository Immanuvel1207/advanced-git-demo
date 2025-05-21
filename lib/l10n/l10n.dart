import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale('ta'), // Tamil
    const Locale('te'), // Telugu
    const Locale('kn'), // Kannada
    const Locale('hi'), // Hindi
  ];
  
  static String getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'ta': return 'Tamil';
      case 'te': return 'Telugu';
      case 'kn': return 'Kannada';
      case 'hi': return 'Hindi';
      default: return 'English';
    }
  }
}