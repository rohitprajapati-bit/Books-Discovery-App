import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/router/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // Auth Routes
    AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
    AutoRoute(page: SignupRoute.page, path: '/signup'),

    // Main Navigation with nested tabs
    AutoRoute(
      page: MainNavigationShellRoute.page,
      path: '/main',
      children: [
        AutoRoute(
          page: HomeTabRoute.page,
          path: 'home',
          initial: true,
          children: [AutoRoute(page: HomeRoute.page, path: '', initial: true)],
        ),
        AutoRoute(
          page: AnalyticsTabRoute.page,
          path: 'analytics',
          children: [
            AutoRoute(page: AnalyticsRoute.page, path: '', initial: true),
          ],
        ),
        AutoRoute(
          page: ContactsTabRoute.page,
          path: 'contacts',
          children: [
            AutoRoute(page: ContactsRoute.page, path: '', initial: true),
          ],
        ),
        AutoRoute(
          page: ProfileTabRoute.page,
          path: 'profile',
          children: [
            AutoRoute(page: ProfileRoute.page, path: '', initial: true),
          ],
        ),
      ],
    ),
  ];
}
