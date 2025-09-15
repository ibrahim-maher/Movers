// lib/modules/load/routes/load_routes.dart

import 'package:get/get.dart';
import '../pages/loads_list_page.dart';
import '../pages/load_details_page.dart';
import '../pages/create_load_page.dart';
import '../bindings/load_binding.dart';
import '../bindings/load_list_binding.dart';
import '../bindings/load_details_binding.dart';
import '../bindings/create_load_binding.dart';

class LoadRoutes {
  static const String loadsList = '/loads';
  static const String loadDetails = '/load-details';
  static const String createLoad = '/create-load';
  static const String editLoad = '/edit-load';
  static const String loadTracking = '/load-tracking';

  static List<GetPage> routes = [
    GetPage(
      name: loadsList,
      page: () => const LoadsListPage(),
      binding: LoadListBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: loadDetails,
      page: () => const LoadDetailsPage(),
      binding: LoadDetailsBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: createLoad,
      page: () => const CreateLoadPage(),
      binding: CreateLoadBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}

// Add this to your main app routes file (app_routes.dart or similar):
/*
class AppRoutes {
  static List<GetPage> get routes => [
    ...LoadRoutes.routes,
    // ... other module routes
  ];
}
*/