import 'package:flutter/material.dart';
import 'app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Check if the locale is supported
    return ['en', 'ta', 'hi', 'te', 'kn', 'ur'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Create a new instance of the class
    AppLocalizations localizations = AppLocalizations(locale);
    
    // Load the translations
    await localizations.load();
    
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}