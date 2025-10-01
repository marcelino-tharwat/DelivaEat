import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My App'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'DelivaEat Login'**
  String get app_title;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'DelivaEat'**
  String get app_name;

  /// No description provided for @app_tagline.
  ///
  /// In en, this message translates to:
  /// **'Delicious Food Delivered'**
  String get app_tagline;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome_back;

  /// No description provided for @login_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get login_to_continue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get no_account;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get create_account;

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get email_hint;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get password_hint;

  /// No description provided for @signup_header_title.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get signup_header_title;

  /// No description provided for @signup_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get signup_already_have_account;

  /// No description provided for @signup_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signup_login;

  /// No description provided for @signup_create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signup_create_account;

  /// No description provided for @signup_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get signup_success;

  /// No description provided for @role_selector_title.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get role_selector_title;

  /// No description provided for @role_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get role_user;

  /// No description provided for @role_rider.
  ///
  /// In en, this message translates to:
  /// **'Rider'**
  String get role_rider;

  /// No description provided for @role_merchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get role_merchant;

  /// No description provided for @rider_info_title.
  ///
  /// In en, this message translates to:
  /// **'Rider Information'**
  String get rider_info_title;

  /// No description provided for @vehicle_type_label.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicle_type_label;

  /// No description provided for @vehicle_motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get vehicle_motorcycle;

  /// No description provided for @vehicle_bicycle.
  ///
  /// In en, this message translates to:
  /// **'Bicycle'**
  String get vehicle_bicycle;

  /// No description provided for @vehicle_scooter.
  ///
  /// In en, this message translates to:
  /// **'Scooter'**
  String get vehicle_scooter;

  /// No description provided for @profile_photo.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profile_photo;

  /// No description provided for @id_card_photo.
  ///
  /// In en, this message translates to:
  /// **'ID Card Photo'**
  String get id_card_photo;

  /// No description provided for @license_photo.
  ///
  /// In en, this message translates to:
  /// **'License Photo'**
  String get license_photo;

  /// No description provided for @vehicle_photo_front.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo (Front)'**
  String get vehicle_photo_front;

  /// No description provided for @vehicle_photo_side.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo (Side)'**
  String get vehicle_photo_side;

  /// No description provided for @license_plate_photo.
  ///
  /// In en, this message translates to:
  /// **'License Plate Photo'**
  String get license_plate_photo;

  /// No description provided for @select_photo.
  ///
  /// In en, this message translates to:
  /// **'Select Photo'**
  String get select_photo;

  /// No description provided for @change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get change_photo;

  /// No description provided for @merchant_info_title.
  ///
  /// In en, this message translates to:
  /// **'Merchant Information'**
  String get merchant_info_title;

  /// No description provided for @business_type_label.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get business_type_label;

  /// No description provided for @business_type_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get business_type_restaurant;

  /// No description provided for @business_type_grocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery Store'**
  String get business_type_grocery;

  /// No description provided for @business_type_pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get business_type_pharmacy;

  /// No description provided for @business_type_bakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get business_type_bakery;

  /// No description provided for @business_name.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get business_name;

  /// No description provided for @owner_name.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get owner_name;

  /// No description provided for @owner_phone.
  ///
  /// In en, this message translates to:
  /// **'Owner Phone'**
  String get owner_phone;

  /// No description provided for @business_description.
  ///
  /// In en, this message translates to:
  /// **'Business Description'**
  String get business_description;

  /// No description provided for @delivery_radius.
  ///
  /// In en, this message translates to:
  /// **'Delivery Radius (KM)'**
  String get delivery_radius;

  /// No description provided for @basic_info_title.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basic_info_title;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @error_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get error_required;

  /// No description provided for @error_name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get error_name_required;

  /// No description provided for @error_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get error_email_required;

  /// No description provided for @error_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get error_password_required;

  /// No description provided for @error_phone_required.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get error_phone_required;

  /// No description provided for @getting_location.
  ///
  /// In en, this message translates to:
  /// **'Getting Location...'**
  String get getting_location;

  /// No description provided for @pick_on_map.
  ///
  /// In en, this message translates to:
  /// **'Pick on Map'**
  String get pick_on_map;

  /// No description provided for @enter_address_manually.
  ///
  /// In en, this message translates to:
  /// **'Enter Address Manually'**
  String get enter_address_manually;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @enter_address.
  ///
  /// In en, this message translates to:
  /// **'Enter Address'**
  String get enter_address;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @current_location_label.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get current_location_label;

  /// No description provided for @selected_address.
  ///
  /// In en, this message translates to:
  /// **'Selected Address:'**
  String get selected_address;

  /// No description provided for @no_location_selected.
  ///
  /// In en, this message translates to:
  /// **'No location selected'**
  String get no_location_selected;

  /// No description provided for @location_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get location_permission_denied;

  /// No description provided for @location_permissions_permanently_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions permanently denied'**
  String get location_permissions_permanently_denied;

  /// No description provided for @failed_to_get_location.
  ///
  /// In en, this message translates to:
  /// **'Failed to get location'**
  String get failed_to_get_location;

  /// No description provided for @interactive_map.
  ///
  /// In en, this message translates to:
  /// **'Interactive Map'**
  String get interactive_map;

  /// No description provided for @google_maps_integration.
  ///
  /// In en, this message translates to:
  /// **'Google Maps integration would go here'**
  String get google_maps_integration;

  /// No description provided for @tap_on_map_to_select_location.
  ///
  /// In en, this message translates to:
  /// **'Tap on map to select location'**
  String get tap_on_map_to_select_location;

  /// No description provided for @enter_your_complete_address.
  ///
  /// In en, this message translates to:
  /// **'Enter your complete address...'**
  String get enter_your_complete_address;

  /// No description provided for @error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get error_connection_timeout;

  /// No description provided for @error_send_timeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout'**
  String get error_send_timeout;

  /// No description provided for @error_receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout'**
  String get error_receive_timeout;

  /// No description provided for @error_bad_certificate.
  ///
  /// In en, this message translates to:
  /// **'Bad certificate'**
  String get error_bad_certificate;

  /// No description provided for @error_request_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get error_request_cancelled;

  /// No description provided for @error_connection_error.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get error_connection_error;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Oops there was an error, please try later'**
  String get error_unknown;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'Your request not found, please try later'**
  String get error_not_found;

  /// No description provided for @error_internal_server.
  ///
  /// In en, this message translates to:
  /// **'Internal server error, please try later'**
  String get error_internal_server;

  /// No description provided for @error_processing_response.
  ///
  /// In en, this message translates to:
  /// **'Error processing server response'**
  String get error_processing_response;

  /// No description provided for @forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password_title;

  /// No description provided for @forgot_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password easily'**
  String get forgot_password_subtitle;

  /// No description provided for @reset_password_header.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_header;

  /// No description provided for @reset_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a reset code'**
  String get reset_password_description;

  /// No description provided for @reset_password_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get reset_password_invalid_email;

  /// No description provided for @reset_password_button.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get reset_password_button;

  /// No description provided for @reset_password_info.
  ///
  /// In en, this message translates to:
  /// **'Check your email inbox and spam folder for the reset code'**
  String get reset_password_info;

  /// No description provided for @back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get back_to_login;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get errorPasswordLowercase;

  /// No description provided for @errorPasswordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get errorPasswordUppercase;

  /// No description provided for @errorPasswordNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get errorPasswordNumber;

  /// No description provided for @errorPasswordSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get errorPasswordSpecialChar;

  /// No description provided for @errorPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get errorPasswordMinLength;

  /// No description provided for @password_requirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements:'**
  String get password_requirements;

  /// No description provided for @new_password_title.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password_title;

  /// No description provided for @new_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password for your account'**
  String get new_password_subtitle;

  /// No description provided for @new_password_header.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get new_password_header;

  /// No description provided for @new_password_description.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password. Make sure it meets all the security requirements below.'**
  String get new_password_description;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @new_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get new_password_hint;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirm_password_hint;

  /// No description provided for @update_password_button.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password_button;

  /// No description provided for @new_password_security_info.
  ///
  /// In en, this message translates to:
  /// **'Your password will be encrypted and stored securely. We recommend using a unique password that you don\'t use elsewhere.'**
  String get new_password_security_info;

  /// No description provided for @password_reset_success.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully! You can now login with your new password.'**
  String get password_reset_success;

  /// No description provided for @error_password_invalid.
  ///
  /// In en, this message translates to:
  /// **'Password doesn\'t meet requirements'**
  String get error_password_invalid;

  /// No description provided for @error_confirm_password_required.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get error_confirm_password_required;

  /// No description provided for @error_password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get error_password_mismatch;

  /// No description provided for @back_to_previous.
  ///
  /// In en, this message translates to:
  /// **'Back to Previous'**
  String get back_to_previous;

  /// No description provided for @enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enter_verification_code;

  /// No description provided for @sent_code_to.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to\n'**
  String get sent_code_to;

  /// No description provided for @verify_code.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verify_code;

  /// No description provided for @didnt_receive_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code? '**
  String get didnt_receive_code;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resend_in.
  ///
  /// In en, this message translates to:
  /// **'Resend in {time}s'**
  String resend_in(Object time);

  /// No description provided for @verify_otp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verify_otp;

  /// No description provided for @enter_code_sent_to_email.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email'**
  String get enter_code_sent_to_email;

  /// No description provided for @code_verified_successfully.
  ///
  /// In en, this message translates to:
  /// **'Code verified successfully!'**
  String get code_verified_successfully;

  /// No description provided for @invalid_or_expired_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code.'**
  String get invalid_or_expired_code;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknown_error;

  /// No description provided for @invalid_code.
  ///
  /// In en, this message translates to:
  /// **'Invalid code.'**
  String get invalid_code;

  /// No description provided for @new_code_sent.
  ///
  /// In en, this message translates to:
  /// **'A new code has been sent to'**
  String new_code_sent(Object email);

  /// No description provided for @or_continue_with.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get or_continue_with;

  /// No description provided for @deliveryTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get deliveryTo;

  /// No description provided for @homePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePageTitle;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @offersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offersTitle;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @offersAndBrands.
  ///
  /// In en, this message translates to:
  /// **'Offers & Brands'**
  String get offersAndBrands;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @topRatedRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Top Rated Restaurants'**
  String get topRatedRestaurants;

  /// No description provided for @bestSelling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get bestSelling;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @availableForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Available for delivery'**
  String get availableForDelivery;

  /// No description provided for @viewMenu.
  ///
  /// In en, this message translates to:
  /// **'View Menu'**
  String get viewMenu;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @readAll.
  ///
  /// In en, this message translates to:
  /// **'Read All'**
  String get readAll;

  /// No description provided for @offerTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Deals'**
  String get offerTodayTitle;

  /// No description provided for @offerTodaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'29% Discount'**
  String get offerTodaySubtitle;

  /// No description provided for @offerFreeDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery'**
  String get offerFreeDeliveryTitle;

  /// No description provided for @offerFreeDeliverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'For the first order'**
  String get offerFreeDeliverySubtitle;

  /// No description provided for @offerPizzaTitle.
  ///
  /// In en, this message translates to:
  /// **'50% Off'**
  String get offerPizzaTitle;

  /// No description provided for @offerPizzaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On Pizza'**
  String get offerPizzaSubtitle;

  /// No description provided for @offerFreeDiscount.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get offerFreeDiscount;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryGrocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get categoryGrocery;

  /// No description provided for @categoryMarkets.
  ///
  /// In en, this message translates to:
  /// **'Markets'**
  String get categoryMarkets;

  /// No description provided for @categoryPharmacies.
  ///
  /// In en, this message translates to:
  /// **'Pharmacies'**
  String get categoryPharmacies;

  /// No description provided for @categoryGifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts & Donate'**
  String get categoryGifts;

  /// No description provided for @categoryStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get categoryStores;

  /// No description provided for @tagDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get tagDiscounts;

  /// No description provided for @tagNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get tagNew;

  /// No description provided for @tagFreeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery'**
  String get tagFreeDelivery;

  /// No description provided for @tagFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get tagFast;

  /// No description provided for @tagHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get tagHealthy;

  /// No description provided for @tagDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get tagDrinks;

  /// No description provided for @tagSweets.
  ///
  /// In en, this message translates to:
  /// **'Sweets'**
  String get tagSweets;

  /// Snackbar message when an offer is tapped
  ///
  /// In en, this message translates to:
  /// **'Tapped on offer: {offerTitle}'**
  String offerTappedSnackbar(String offerTitle);

  /// Snackbar message when a category is tapped
  ///
  /// In en, this message translates to:
  /// **'Selected category: {categoryName}'**
  String categoryTappedSnackbar(String categoryName);

  /// No description provided for @pharmaciesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Pharmacies Section'**
  String get pharmaciesSectionTitle;

  /// No description provided for @searchPharmaciesHint.
  ///
  /// In en, this message translates to:
  /// **'Search for pharmacies, medicines...'**
  String get searchPharmaciesHint;

  /// No description provided for @highestRated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get highestRated;

  /// No description provided for @fastestDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fastest Delivery'**
  String get fastestDelivery;

  /// No description provided for @freeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery'**
  String get freeDelivery;

  /// No description provided for @discount20OnMedicines.
  ///
  /// In en, this message translates to:
  /// **'20% Discount on Medicines'**
  String get discount20OnMedicines;

  /// No description provided for @useCodePharma20.
  ///
  /// In en, this message translates to:
  /// **'Use code: PHARMA20'**
  String get useCodePharma20;

  /// No description provided for @freeDeliveryOnMedicines.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery on Medicines'**
  String get freeDeliveryOnMedicines;

  /// No description provided for @forAllParticipatingPharmacies.
  ///
  /// In en, this message translates to:
  /// **'For all participating pharmacies'**
  String get forAllParticipatingPharmacies;

  /// No description provided for @offersOnCosmetics.
  ///
  /// In en, this message translates to:
  /// **'Offers on Cosmetics'**
  String get offersOnCosmetics;

  /// No description provided for @discoverOurNewOffers.
  ///
  /// In en, this message translates to:
  /// **'Discover our new offers'**
  String get discoverOurNewOffers;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @nutritionalSupplements.
  ///
  /// In en, this message translates to:
  /// **'Nutritional Supplements'**
  String get nutritionalSupplements;

  /// No description provided for @personalCare.
  ///
  /// In en, this message translates to:
  /// **'Personal Care'**
  String get personalCare;

  /// No description provided for @cosmetics.
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get cosmetics;

  /// No description provided for @motherAndBabyCare.
  ///
  /// In en, this message translates to:
  /// **'Mother and Baby Care'**
  String get motherAndBabyCare;

  /// No description provided for @medicalEquipment.
  ///
  /// In en, this message translates to:
  /// **'Medical Equipment'**
  String get medicalEquipment;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Delivery fee text with amount
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee: {fee} Riyal'**
  String deliveryFee(String fee);

  /// No description provided for @foodSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Section'**
  String get foodSectionTitle;

  /// No description provided for @searchRestaurantsHint.
  ///
  /// In en, this message translates to:
  /// **'Search for restaurants, foods...'**
  String get searchRestaurantsHint;

  /// No description provided for @discount50OnFirstOrder.
  ///
  /// In en, this message translates to:
  /// **'50% Discount on First Order'**
  String get discount50OnFirstOrder;

  /// No description provided for @useCodeNew50.
  ///
  /// In en, this message translates to:
  /// **'Use code: NEW50'**
  String get useCodeNew50;

  /// No description provided for @freeDeliveryThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Free Delivery This Week'**
  String get freeDeliveryThisWeek;

  /// No description provided for @familyMealsAtSpecialPrices.
  ///
  /// In en, this message translates to:
  /// **'Family Meals at Special Prices'**
  String get familyMealsAtSpecialPrices;

  /// No description provided for @failedToLoadRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Failed to load restaurants, try later'**
  String get failedToLoadRestaurants;

  /// No description provided for @failedToLoadCategoryRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Failed to load category restaurants, try later'**
  String get failedToLoadCategoryRestaurants;

  /// No description provided for @thisCategoryNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This category is not available currently'**
  String get thisCategoryNotAvailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @forAllParticipatingRestaurants.
  ///
  /// In en, this message translates to:
  /// **'For all participating restaurants'**
  String get forAllParticipatingRestaurants;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchRestaurantsFoodsHint.
  ///
  /// In en, this message translates to:
  /// **'Search for restaurants or foods...'**
  String get searchRestaurantsFoodsHint;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurants;

  /// No description provided for @otherProducts.
  ///
  /// In en, this message translates to:
  /// **'Other Products'**
  String get otherProducts;

  /// Products section title for a specific restaurant
  ///
  /// In en, this message translates to:
  /// **'Products of {restaurantName}'**
  String restaurantProducts(String restaurantName);

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No search results'**
  String get noSearchResults;

  /// No description provided for @noResultsFor.
  ///
  /// In en, this message translates to:
  /// **'We didn\'t find any results for '**
  String get noResultsFor;

  /// No description provided for @tryDifferentWords.
  ///
  /// In en, this message translates to:
  /// **'Try different words or check spelling'**
  String get tryDifferentWords;

  /// No description provided for @popularSearch.
  ///
  /// In en, this message translates to:
  /// **'Popular Search'**
  String get popularSearch;

  /// No description provided for @startSearching.
  ///
  /// In en, this message translates to:
  /// **'Start Searching'**
  String get startSearching;

  /// No description provided for @searchFavorites.
  ///
  /// In en, this message translates to:
  /// **'Search for your favorite restaurants and foods'**
  String get searchFavorites;

  /// No description provided for @categoryPizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get categoryPizza;

  /// No description provided for @categoryBurger.
  ///
  /// In en, this message translates to:
  /// **'Burger'**
  String get categoryBurger;

  /// No description provided for @categoryCrepes.
  ///
  /// In en, this message translates to:
  /// **'Crepes'**
  String get categoryCrepes;

  /// No description provided for @categoryDesserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get categoryDesserts;

  /// No description provided for @categoryGrills.
  ///
  /// In en, this message translates to:
  /// **'Grills'**
  String get categoryGrills;

  /// No description provided for @categoryFriedChicken.
  ///
  /// In en, this message translates to:
  /// **'Fried Chicken'**
  String get categoryFriedChicken;

  /// No description provided for @categoryKoshary.
  ///
  /// In en, this message translates to:
  /// **'Koshary'**
  String get categoryKoshary;

  /// No description provided for @categoryBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get categoryBreakfast;

  /// No description provided for @categoryPies.
  ///
  /// In en, this message translates to:
  /// **'Pies'**
  String get categoryPies;

  /// No description provided for @categorySandwich.
  ///
  /// In en, this message translates to:
  /// **'Sandwich'**
  String get categorySandwich;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @riyal.
  ///
  /// In en, this message translates to:
  /// **'Riyal'**
  String get riyal;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @deliveryFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee: '**
  String get deliveryFeeLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
