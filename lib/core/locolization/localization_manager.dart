import 'package:flutter/material.dart';



class LocalizationManager {
  LocalizationManager._();

  static const String translationsPath = 'assets/lang';
  static const Locale fallbackLocale = Locale('en');

  static const List<Locale> supportedLocales = [
    Locale('en'), 
    Locale('ar'), 
  ];

  
  static bool isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }

  
  static Locale getLocale(String languageCode) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => fallbackLocale,
    );
  }
}

