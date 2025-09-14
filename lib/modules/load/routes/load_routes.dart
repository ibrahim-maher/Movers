import 'package:get/get.dart';

import '../../auth/middleware/auth_middleware.dart';
import '../bindings/create_load_binding.dart';
import '../bindings/load_binding.dart';
import '../bindings/load_details_binding.dart';
import '../bindings/load_list_binding.dart';
import '../bindings/load_tracking_binding.dart';
import '../pages/create_load_page.dart';
import '../pages/edit_load_page.dart';
import '../pages/load_details_page.dart';
import '../pages/load_tracking_page.dart';
import '../pages/loads_list_page.dart';

class LoadRoutes {
  static final routes = [
    GetPage(
      name: '/load/list',
      page: () => const LoadsListPage(),
      binding: LoadListBinding(),
      middlewares: [AuthMiddleware()],
      bindings: [LoadBinding()],
    ),
    GetPage(
      name: '/load/details/:id',
      page: () => const LoadDetailsPage(),
      binding: LoadDetailsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/load/create',
      page: () => const CreateLoadPage(),
      binding: CreateLoadBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/load/edit/:id',
      page: () => const EditLoadPage(),
      binding: CreateLoadBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/load/tracking/:id',
      page: () => const LoadTrackingPage(),
      binding: LoadTrackingBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}