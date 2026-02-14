// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:books_discovery_app/core/navigation/main_navigation_shell_page.dart'
    as _i9;
import 'package:books_discovery_app/core/navigation/tabs/analytics_tab_page.dart'
    as _i2;
import 'package:books_discovery_app/core/navigation/tabs/contacts_tab_page.dart'
    as _i5;
import 'package:books_discovery_app/core/navigation/tabs/home_tab_page.dart'
    as _i7;
import 'package:books_discovery_app/core/navigation/tabs/profile_tab_page.dart'
    as _i11;
import 'package:books_discovery_app/feature/analytics/presentation/screen/analytics_page.dart'
    as _i1;
import 'package:books_discovery_app/feature/auth/presentation/login/login_page.dart'
    as _i8;
import 'package:books_discovery_app/feature/auth/presentation/register/signup_page.dart'
    as _i13;
import 'package:books_discovery_app/feature/auth/presentation/splash/splash_page.dart'
    as _i14;
import 'package:books_discovery_app/feature/contacts/presentation/screen/contacts_page.dart'
    as _i4;
import 'package:books_discovery_app/feature/home/domain/entities/book.dart'
    as _i17;
import 'package:books_discovery_app/feature/home/presentation/screen/book_details_page.dart'
    as _i3;
import 'package:books_discovery_app/feature/home/presentation/screen/home_page.dart'
    as _i6;
import 'package:books_discovery_app/feature/home/presentation/screen/qr_scanner_page.dart'
    as _i12;
import 'package:books_discovery_app/feature/profile/presentation/screen/profile_page.dart'
    as _i10;
import 'package:flutter/material.dart' as _i16;

/// generated route for
/// [_i1.AnalyticsPage]
class AnalyticsRoute extends _i15.PageRouteInfo<void> {
  const AnalyticsRoute({List<_i15.PageRouteInfo>? children})
    : super(AnalyticsRoute.name, initialChildren: children);

  static const String name = 'AnalyticsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i1.AnalyticsPage();
    },
  );
}

/// generated route for
/// [_i2.AnalyticsTabPage]
class AnalyticsTabRoute extends _i15.PageRouteInfo<void> {
  const AnalyticsTabRoute({List<_i15.PageRouteInfo>? children})
    : super(AnalyticsTabRoute.name, initialChildren: children);

  static const String name = 'AnalyticsTabRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i2.AnalyticsTabPage();
    },
  );
}

/// generated route for
/// [_i3.BookDetailsPage]
class BookDetailsRoute extends _i15.PageRouteInfo<BookDetailsRouteArgs> {
  BookDetailsRoute({
    _i16.Key? key,
    required _i17.Book book,
    List<_i15.PageRouteInfo>? children,
  }) : super(
         BookDetailsRoute.name,
         args: BookDetailsRouteArgs(key: key, book: book),
         initialChildren: children,
       );

  static const String name = 'BookDetailsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookDetailsRouteArgs>();
      return _i3.BookDetailsPage(key: args.key, book: args.book);
    },
  );
}

class BookDetailsRouteArgs {
  const BookDetailsRouteArgs({this.key, required this.book});

  final _i16.Key? key;

  final _i17.Book book;

  @override
  String toString() {
    return 'BookDetailsRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [_i4.ContactsPage]
class ContactsRoute extends _i15.PageRouteInfo<void> {
  const ContactsRoute({List<_i15.PageRouteInfo>? children})
    : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i4.ContactsPage();
    },
  );
}

/// generated route for
/// [_i5.ContactsTabPage]
class ContactsTabRoute extends _i15.PageRouteInfo<void> {
  const ContactsTabRoute({List<_i15.PageRouteInfo>? children})
    : super(ContactsTabRoute.name, initialChildren: children);

  static const String name = 'ContactsTabRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i5.ContactsTabPage();
    },
  );
}

/// generated route for
/// [_i6.HomePage]
class HomeRoute extends _i15.PageRouteInfo<void> {
  const HomeRoute({List<_i15.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i6.HomePage();
    },
  );
}

/// generated route for
/// [_i7.HomeTabPage]
class HomeTabRoute extends _i15.PageRouteInfo<void> {
  const HomeTabRoute({List<_i15.PageRouteInfo>? children})
    : super(HomeTabRoute.name, initialChildren: children);

  static const String name = 'HomeTabRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomeTabPage();
    },
  );
}

/// generated route for
/// [_i8.LoginPage]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute({List<_i15.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i8.LoginPage();
    },
  );
}

/// generated route for
/// [_i9.MainNavigationShellPage]
class MainNavigationShellRoute extends _i15.PageRouteInfo<void> {
  const MainNavigationShellRoute({List<_i15.PageRouteInfo>? children})
    : super(MainNavigationShellRoute.name, initialChildren: children);

  static const String name = 'MainNavigationShellRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i9.MainNavigationShellPage();
    },
  );
}

/// generated route for
/// [_i10.ProfilePage]
class ProfileRoute extends _i15.PageRouteInfo<void> {
  const ProfileRoute({List<_i15.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i10.ProfilePage();
    },
  );
}

/// generated route for
/// [_i11.ProfileTabPage]
class ProfileTabRoute extends _i15.PageRouteInfo<void> {
  const ProfileTabRoute({List<_i15.PageRouteInfo>? children})
    : super(ProfileTabRoute.name, initialChildren: children);

  static const String name = 'ProfileTabRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i11.ProfileTabPage();
    },
  );
}

/// generated route for
/// [_i12.QRScannerPage]
class QRScannerRoute extends _i15.PageRouteInfo<void> {
  const QRScannerRoute({List<_i15.PageRouteInfo>? children})
    : super(QRScannerRoute.name, initialChildren: children);

  static const String name = 'QRScannerRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i12.QRScannerPage();
    },
  );
}

/// generated route for
/// [_i13.SignupPage]
class SignupRoute extends _i15.PageRouteInfo<void> {
  const SignupRoute({List<_i15.PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i13.SignupPage();
    },
  );
}

/// generated route for
/// [_i14.SplashPage]
class SplashRoute extends _i15.PageRouteInfo<void> {
  const SplashRoute({List<_i15.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i15.PageInfo page = _i15.PageInfo(
    name,
    builder: (data) {
      return const _i14.SplashPage();
    },
  );
}
