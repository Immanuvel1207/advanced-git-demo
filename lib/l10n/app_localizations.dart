import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_localizations_delegate.dart';

class AppLocalizations {
  final Locale locale;
  
  // Cache for translations to reduce API calls
  static Map<String, Map<String, String>> _translationCache = {};
  
  // Default English translations for common UI elements
  static final Map<String, String> _defaultEnglishTranslations = {
    'app_name': 'Nanjundeshwara Stores',
    'login': 'Login',
    'logout': 'Logout',
    'user_id': 'User ID',
    'phone_number': 'Phone Number',
    'invalid_credentials': 'Invalid credentials. Please try again.',
    'login_failed': 'Login failed. Please try again.',
    'error_occurred': 'An error occurred. Please try again later.',
    'welcome': 'Welcome',
    'actions': 'Actions',
    'categories': 'Categories',
    'view_more': 'View More',
    'products': 'Products',
    'address': 'Address',
    'directions': 'Directions',
    'call': 'Call',
    'admin_dashboard': 'Admin Dashboard',
    'operations': 'Operations',
    'pending_payments': 'Pending Payments',
    'trash': 'Trash',
    'add_user': 'Add User',
    'delete_user': 'Delete User',
    'view_all_users': 'View All Users',
    'add_payment': 'Add Payment',
    'view_payments': 'View Payments',
    'view_payments_by_month': 'View Payments by Month',
    'search_by_village': 'Search By Village',
    'inactive_customers': 'Inactive Customers',
    'name': 'Name',
    'village': 'Village',
    'category': 'Category',
    'amount': 'Amount',
    'month': 'Month',
    'search_users': 'Search Users',
    'total_users': 'Total Users',
    'refresh_users_list': 'Refresh Users List',
    'move_user_to_trash': 'Move User to Trash',
    'confirm_deletion': 'Confirm Deletion',
    'are_you_sure_delete': 'Are you sure you want to move this user to trash?',
    'user_details': 'User Details',
    'cancel': 'Cancel',
    'move_to_trash': 'Move to Trash',
    'user_moved_to_trash': 'User moved to trash successfully',
    'failed_to_delete_user': 'Failed to delete user',
    'payment_history': 'Payment History',
    'no_payments_found': 'No payments found.',
    'make_payment': 'Make Payment',
    'transaction_id': 'Transaction ID',
    'submit_payment': 'Submit Payment',
    'payment_request_submitted': 'Payment request submitted successfully',
    'payment_already_made': 'Payment for month {month} is already made.',
    'please_enter_transaction_id': 'Please enter a transaction ID',
    'no_deleted_users_found': 'No deleted users found',
    'restore_user': 'Restore User',
    'delete_permanently': 'Delete Permanently',
    'permanently_delete_user': 'Permanently Delete User',
    'are_you_sure_permanent_delete': 'Are you sure you want to permanently delete {name} (ID: {id})? This action cannot be undone.',
    'user_restored': 'User restored successfully',
    'user_permanently_deleted': 'User permanently deleted',
    'no_pending_payment_requests': 'No pending payment requests.',
    'language': 'Language',
    'select_language': 'Select Language',
    'english': 'English',
    'tamil': 'Tamil',
    'hindi': 'Hindi',
    'telugu': 'Telugu',
    'kannada': 'Kannada',
    'urdu': 'Urdu',
    'language_settings': 'Language Settings',
    'language_updated': 'Language updated successfully',
    'service_description': 'Specialized in Diwali Chits with various categories to choose from.',
    'nanjappan': 'Nanjappan',
    'suselamma': 'Suselamma',
    'honoured': 'Honoured',
    'owner': 'Owner',
    'location_permission_denied': 'Location permission denied',
    'location_permission_permanently_denied': 'Location permissions permanently denied, please enable in settings',
    'could_not_open_maps': 'Could not open maps',
    'error_opening_maps': 'Error opening maps',
    'cannot_open_phone_dialer': 'Cannot open phone dialer',
    'error_making_phone_call': 'Error making phone call',
    'gold_category': 'Gold',
    'silver_category': 'Silver',
    'bronze_category': 'Bronze',
    'per_month': 'per month',
    'rice': 'Rice',
    'maida': 'Maida',
    'oil': 'Oil',
    'wheat_flour': 'Wheat Flour',
    'white_dhall': 'White Dhall',
    'rice_raw': 'Rice Raw',
    'semiya': 'Semiya',
    'payasam_mix': 'Payasam Mix',
    'sugar': 'Sugar',
    'sesame_oil': 'Sesame Oil',
    'tamarind': 'Tamarind',
    'dry_chilli': 'Dry Chilli',
    'coriander_seeds': 'Coriander Seeds',
    'salt': 'Salt',
    'jaggery': 'Jaggery',
    'pattasu_box': 'Pattasu Box',
    'matches_box': 'Matches Box',
    'turmeric_powder': 'Turmeric Powder',
    'kumkum': 'Kumkum',
    'camphor': 'Camphor',
    'pack': 'Pack',
    'box': 'Box',
    'liters': 'Liters',
    'liter': 'Liter',
    'grams': 'grams',
    'pieces': 'pieces',
    'please_enter_user_id': 'Please enter your User ID',
    'please_enter_phone_number': 'Please enter your phone number',
    'please_enter_user_id_to_delete': 'Please enter a User ID to delete',
    'please_enter_user_id_to_view_payments': 'Please enter a User ID to view payments',
    'please_enter_month_to_view_payments': 'Please enter a month to view payments',
    'please_enter_name': 'Please enter a name',
    'please_enter_village': 'Please enter a village',
    'please_enter_amount': 'Please enter an amount',
    'please_enter_month': 'Please enter a month',
    'please_select_village': 'Please select a village',
    'search': 'Search',
    'customers_in': 'Customers in',
    'refresh_inactive_customers': 'Refresh Inactive Customers',
    'last_payment': 'Last Payment',
    'admin_operations': 'Admin Operations',
    'add_user': 'Add User',
    'user_dashboard': 'User Dashboard',
    'notifications': 'Notifications',
    'no_notifications': 'No notifications',
    'payment_approved': 'Payment approved successfully',
    'payment_rejected': 'Payment rejected successfully',
    'approve': 'Approve',
    'reject': 'Reject',
    'month_format': 'Month (e.g., 01 for January)',
    'paid': 'Paid',
    'unpaid': 'Unpaid',
    'no_paid_users': 'No paid users for this month',
    'no_unpaid_users': 'No unpaid users for this month',
    'payments': 'Payments',
    'user': 'User',
    'deleted_on': 'Deleted on',
    'qr_code_not_available': 'QR Code not available',
    'contact_admin_for_payment_details': 'Please contact admin for payment details',
    'failed_to_submit_payment_request': 'Failed to submit payment request',
  };
  
  AppLocalizations(this.locale);
  
  // Helper method to keep the code in the widgets concise
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();
  
  // List of supported languages
  static final List<Locale> supportedLocales = [
    const Locale('en', ''), // English
    const Locale('ta', ''), // Tamil
    const Locale('hi', ''), // Hindi
    const Locale('te', ''), // Telugu
    const Locale('kn', ''), // Kannada
    const Locale('ur', ''), // Urdu
  ];
  
  // Method to get the current locale from shared preferences
  static Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('languageCode') ?? 'en';
    return Locale(languageCode, '');
  }
  
  // Method to set the locale in shared preferences
  static Future<void> setLocale(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
  
  // Method to update the user's language preference on the server
  static Future<void> updateLanguageOnServer(String userId, String languageCode) async {
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/update_language'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': int.parse(userId), 'language': languageCode}),
      );
      
      if (response.statusCode != 200) {
        print('Failed to update language on server: ${response.body}');
      }
    } catch (e) {
      print('Error updating language on server: $e');
    }
  }
  
  // Translations map
  late Map<String, String> _localizedStrings;
  
  Future<bool> load() async {
    // Load translations for the current locale
    _localizedStrings = await _loadTranslations(locale.languageCode);
    return true;
  }
  
  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    // If the key doesn't exist in the translations, return the key itself
    // or the English default if available
    return _localizedStrings[key] ?? _defaultEnglishTranslations[key] ?? key;
  }
  
  // Load translations from API or cache
  Future<Map<String, String>> _loadTranslations(String languageCode) async {
    // If language is English, return the default English translations
    if (languageCode == 'en') {
      return Map<String, String>.from(_defaultEnglishTranslations);
    }
    
    // Check if translations are already in cache
    if (_translationCache.containsKey(languageCode)) {
      return _translationCache[languageCode]!;
    }
    
    // Otherwise, fetch translations from API
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/translate-object'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'object': _defaultEnglishTranslations,
          'targetLang': languageCode,
          'sourceLang': 'en'
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translatedObject = data['translatedObject'];
        
        // Convert all values to strings
        final translations = Map<String, String>.from(
          translatedObject.map((key, value) => MapEntry(key, value.toString()))
        );
        
        // Cache the translations
        _translationCache[languageCode] = translations;
        
        return translations;
      } else {
        print('Failed to fetch translations: ${response.body}');
        // Fallback to English if API call fails
        return Map<String, String>.from(_defaultEnglishTranslations);
      }
    } catch (e) {
      print('Error fetching translations: $e');
      
      // Try to use offline translation for common phrases
      try {
        // Fallback to direct translation API for critical UI elements
        final fallbackTranslations = await _translateCriticalElements(languageCode);
        return fallbackTranslations;
      } catch (fallbackError) {
        print('Fallback translation error: $fallbackError');
        // If all else fails, return English
        return Map<String, String>.from(_defaultEnglishTranslations);
      }
    }
  }
  
  // Translate critical UI elements directly using a fallback API
  Future<Map<String, String>> _translateCriticalElements(String languageCode) async {
    // List of critical UI elements that must be translated
    final criticalKeys = [
      'login', 'logout', 'user_id', 'phone_number', 'welcome',
      'actions', 'categories', 'view_more', 'products', 'address',
      'name', 'village', 'category', 'amount', 'month',
      'cancel', 'search', 'language', 'english', 'tamil', 'hindi', 'telugu', 'kannada', 'urdu'
    ];
    
    final Map<String, String> criticalTranslations = {};
    
    // Copy all English translations first
    final result = Map<String, String>.from(_defaultEnglishTranslations);
    
    // Try to translate critical elements using Google Translate API (no key required)
    for (final key in criticalKeys) {
      final text = _defaultEnglishTranslations[key];
      if (text != null) {
        try {
          final encodedText = Uri.encodeComponent(text);
          final url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=$languageCode&dt=t&q=$encodedText';
          
          final response = await http.get(Uri.parse(url));
          
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data != null && data[0] != null && data[0][0] != null && data[0][0][0] != null) {
              final translatedText = data[0][0][0].toString();
              criticalTranslations[key] = translatedText;
            }
          }
        } catch (e) {
          print('Error translating critical element $key: $e');
        }
      }
    }
    
    // Update result with any successful translations
    result.addAll(criticalTranslations);
    
    // Cache these translations
    _translationCache[languageCode] = result;
    
    return result;
  }
  
  // Method to translate a single text on-the-fly
  static Future<String> translateText(String text, String targetLang, {String sourceLang = 'en'}) async {
    // If target language is the same as source, return the original text
    if (targetLang == sourceLang) {
      return text;
    }
    
    try {
      final response = await http.post(
        Uri.parse('https://nanjundeshwara.vercel.app/translate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': text,
          'targetLang': targetLang,
          'sourceLang': sourceLang
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['translatedText'] ?? text;
      } else {
        print('Failed to translate text: ${response.body}');
        return text;
      }
    } catch (e) {
      print('Error translating text: $e');
      
      // Fallback to Google Translate API
      try {
        final encodedText = Uri.encodeComponent(text);
        final url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$sourceLang&tl=$targetLang&dt=t&q=$encodedText';
        
        final response = await http.get(Uri.parse(url));
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data != null && data[0] != null && data[0][0] != null && data[0][0][0] != null) {
            return data[0][0][0].toString();
          }
        }
      } catch (fallbackError) {
        print('Fallback translation error: $fallbackError');
      }
      
      return text;
    }
  }
  
  // Clear translation cache
  static void clearCache() {
    _translationCache.clear();
  }
}