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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings page`
  String get settingstitle {
    return Intl.message(
      'Settings page',
      name: 'settingstitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to ChickenMart`
  String get hometitle {
    return Intl.message(
      'Welcome to ChickenMart',
      name: 'hometitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get loginemail {
    return Intl.message(
      'Email',
      name: 'loginemail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get loginpassword {
    return Intl.message(
      'Password',
      name: 'loginpassword',
      desc: '',
      args: [],
    );
  }

  /// `New User?`
  String get newuser {
    return Intl.message(
      'New User?',
      name: 'newuser',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotpassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotpassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signin {
    return Intl.message(
      'Sign in',
      name: 'signin',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `or continue as`
  String get orcontinueas {
    return Intl.message(
      'or continue as',
      name: 'orcontinueas',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `No Products available`
  String get noproductsavalibel {
    return Intl.message(
      'No Products available',
      name: 'noproductsavalibel',
      desc: '',
      args: [],
    );
  }

  /// `Product: `
  String get productName {
    return Intl.message(
      'Product: ',
      name: 'productName',
      desc: '',
      args: [],
    );
  }

  /// `Weight: `
  String get weight {
    return Intl.message(
      'Weight: ',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Price: `
  String get price {
    return Intl.message(
      'Price: ',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Item added to cart`
  String get itemadded {
    return Intl.message(
      'Item added to cart',
      name: 'itemadded',
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
