// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My App`
  String get appTitle {
    return Intl.message('My App', name: 'appTitle', desc: '', args: []);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Change Theme`
  String get changeTheme {
    return Intl.message(
      'Change Theme',
      name: 'changeTheme',
      desc: '',
      args: [],
    );
  }

  /// `DelivaEat Login`
  String get app_title {
    return Intl.message(
      'DelivaEat Login',
      name: 'app_title',
      desc: '',
      args: [],
    );
  }

  /// `DelivaEat`
  String get app_name {
    return Intl.message('DelivaEat', name: 'app_name', desc: '', args: []);
  }

  /// `Delicious Food Delivered`
  String get app_tagline {
    return Intl.message(
      'Delicious Food Delivered',
      name: 'app_tagline',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcome_back {
    return Intl.message(
      'Welcome Back!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Login to continue`
  String get login_to_continue {
    return Intl.message(
      'Login to continue',
      name: 'login_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get no_account {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'no_account',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get create_account {
    return Intl.message(
      'Create New Account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get email_hint {
    return Intl.message(
      'Enter your email',
      name: 'email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get password_hint {
    return Intl.message(
      'Enter your password',
      name: 'password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get signup_header_title {
    return Intl.message(
      'Create New Account',
      name: 'signup_header_title',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get signup_already_have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'signup_already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get signup_login {
    return Intl.message('Login', name: 'signup_login', desc: '', args: []);
  }

  /// `Create Account`
  String get signup_create_account {
    return Intl.message(
      'Create Account',
      name: 'signup_create_account',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully!`
  String get signup_success {
    return Intl.message(
      'Account created successfully!',
      name: 'signup_success',
      desc: '',
      args: [],
    );
  }

  /// `Account Type`
  String get role_selector_title {
    return Intl.message(
      'Account Type',
      name: 'role_selector_title',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get role_user {
    return Intl.message('User', name: 'role_user', desc: '', args: []);
  }

  /// `Rider`
  String get role_rider {
    return Intl.message('Rider', name: 'role_rider', desc: '', args: []);
  }

  /// `Merchant`
  String get role_merchant {
    return Intl.message('Merchant', name: 'role_merchant', desc: '', args: []);
  }

  /// `Rider Information`
  String get rider_info_title {
    return Intl.message(
      'Rider Information',
      name: 'rider_info_title',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Type`
  String get vehicle_type_label {
    return Intl.message(
      'Vehicle Type',
      name: 'vehicle_type_label',
      desc: '',
      args: [],
    );
  }

  /// `Motorcycle`
  String get vehicle_motorcycle {
    return Intl.message(
      'Motorcycle',
      name: 'vehicle_motorcycle',
      desc: '',
      args: [],
    );
  }

  /// `Bicycle`
  String get vehicle_bicycle {
    return Intl.message('Bicycle', name: 'vehicle_bicycle', desc: '', args: []);
  }

  /// `Scooter`
  String get vehicle_scooter {
    return Intl.message('Scooter', name: 'vehicle_scooter', desc: '', args: []);
  }

  /// `Profile Photo`
  String get profile_photo {
    return Intl.message(
      'Profile Photo',
      name: 'profile_photo',
      desc: '',
      args: [],
    );
  }

  /// `ID Card Photo`
  String get id_card_photo {
    return Intl.message(
      'ID Card Photo',
      name: 'id_card_photo',
      desc: '',
      args: [],
    );
  }

  /// `License Photo`
  String get license_photo {
    return Intl.message(
      'License Photo',
      name: 'license_photo',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Photo (Front)`
  String get vehicle_photo_front {
    return Intl.message(
      'Vehicle Photo (Front)',
      name: 'vehicle_photo_front',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Photo (Side)`
  String get vehicle_photo_side {
    return Intl.message(
      'Vehicle Photo (Side)',
      name: 'vehicle_photo_side',
      desc: '',
      args: [],
    );
  }

  /// `License Plate Photo`
  String get license_plate_photo {
    return Intl.message(
      'License Plate Photo',
      name: 'license_plate_photo',
      desc: '',
      args: [],
    );
  }

  /// `Select Photo`
  String get select_photo {
    return Intl.message(
      'Select Photo',
      name: 'select_photo',
      desc: '',
      args: [],
    );
  }

  /// `Change Photo`
  String get change_photo {
    return Intl.message(
      'Change Photo',
      name: 'change_photo',
      desc: '',
      args: [],
    );
  }

  /// `Merchant Information`
  String get merchant_info_title {
    return Intl.message(
      'Merchant Information',
      name: 'merchant_info_title',
      desc: '',
      args: [],
    );
  }

  /// `Business Type`
  String get business_type_label {
    return Intl.message(
      'Business Type',
      name: 'business_type_label',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant`
  String get business_type_restaurant {
    return Intl.message(
      'Restaurant',
      name: 'business_type_restaurant',
      desc: '',
      args: [],
    );
  }

  /// `Grocery Store`
  String get business_type_grocery {
    return Intl.message(
      'Grocery Store',
      name: 'business_type_grocery',
      desc: '',
      args: [],
    );
  }

  /// `Pharmacy`
  String get business_type_pharmacy {
    return Intl.message(
      'Pharmacy',
      name: 'business_type_pharmacy',
      desc: '',
      args: [],
    );
  }

  /// `Bakery`
  String get business_type_bakery {
    return Intl.message(
      'Bakery',
      name: 'business_type_bakery',
      desc: '',
      args: [],
    );
  }

  /// `Business Name`
  String get business_name {
    return Intl.message(
      'Business Name',
      name: 'business_name',
      desc: '',
      args: [],
    );
  }

  /// `Owner Name`
  String get owner_name {
    return Intl.message('Owner Name', name: 'owner_name', desc: '', args: []);
  }

  /// `Owner Phone`
  String get owner_phone {
    return Intl.message('Owner Phone', name: 'owner_phone', desc: '', args: []);
  }

  /// `Business Description`
  String get business_description {
    return Intl.message(
      'Business Description',
      name: 'business_description',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Radius (KM)`
  String get delivery_radius {
    return Intl.message(
      'Delivery Radius (KM)',
      name: 'delivery_radius',
      desc: '',
      args: [],
    );
  }

  /// `Basic Information`
  String get basic_info_title {
    return Intl.message(
      'Basic Information',
      name: 'basic_info_title',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get error_required {
    return Intl.message('Required', name: 'error_required', desc: '', args: []);
  }

  /// `Name is required`
  String get error_name_required {
    return Intl.message(
      'Name is required',
      name: 'error_name_required',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get error_email_required {
    return Intl.message(
      'Email is required',
      name: 'error_email_required',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get error_password_required {
    return Intl.message(
      'Password is required',
      name: 'error_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Phone is required`
  String get error_phone_required {
    return Intl.message(
      'Phone is required',
      name: 'error_phone_required',
      desc: '',
      args: [],
    );
  }

  /// `Getting Location...`
  String get getting_location {
    return Intl.message(
      'Getting Location...',
      name: 'getting_location',
      desc: '',
      args: [],
    );
  }

  /// `Pick on Map`
  String get pick_on_map {
    return Intl.message('Pick on Map', name: 'pick_on_map', desc: '', args: []);
  }

  /// `Enter Address Manually`
  String get enter_address_manually {
    return Intl.message(
      'Enter Address Manually',
      name: 'enter_address_manually',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Enter Address`
  String get enter_address {
    return Intl.message(
      'Enter Address',
      name: 'enter_address',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Current Location`
  String get current_location_label {
    return Intl.message(
      'Current Location',
      name: 'current_location_label',
      desc: '',
      args: [],
    );
  }

  /// `Selected Address:`
  String get selected_address {
    return Intl.message(
      'Selected Address:',
      name: 'selected_address',
      desc: '',
      args: [],
    );
  }

  /// `No location selected`
  String get no_location_selected {
    return Intl.message(
      'No location selected',
      name: 'no_location_selected',
      desc: '',
      args: [],
    );
  }

  /// `Location permission denied`
  String get location_permission_denied {
    return Intl.message(
      'Location permission denied',
      name: 'location_permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions permanently denied`
  String get location_permissions_permanently_denied {
    return Intl.message(
      'Location permissions permanently denied',
      name: 'location_permissions_permanently_denied',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get location`
  String get failed_to_get_location {
    return Intl.message(
      'Failed to get location',
      name: 'failed_to_get_location',
      desc: '',
      args: [],
    );
  }

  /// `Interactive Map`
  String get interactive_map {
    return Intl.message(
      'Interactive Map',
      name: 'interactive_map',
      desc: '',
      args: [],
    );
  }

  /// `Google Maps integration would go here`
  String get google_maps_integration {
    return Intl.message(
      'Google Maps integration would go here',
      name: 'google_maps_integration',
      desc: '',
      args: [],
    );
  }

  /// `Tap on map to select location`
  String get tap_on_map_to_select_location {
    return Intl.message(
      'Tap on map to select location',
      name: 'tap_on_map_to_select_location',
      desc: '',
      args: [],
    );
  }

  /// `Enter your complete address...`
  String get enter_your_complete_address {
    return Intl.message(
      'Enter your complete address...',
      name: 'enter_your_complete_address',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
