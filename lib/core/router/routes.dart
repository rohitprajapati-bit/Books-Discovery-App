import 'package:auto_route/auto_route.dart';
import 'package:books_discovery_app/core/router/routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // Auth Routes
    AutoRoute(page: LoginScreenRoute.page, path: '/login', initial: true),
    AutoRoute(page: SignupScreenRoute.page, path: '/signup'),

    // Home Route
    AutoRoute(page: HomeScreenRoute.page, path: '/home'),
  ];
}
