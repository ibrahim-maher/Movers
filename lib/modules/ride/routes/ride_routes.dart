import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/middleware/auth_middleware.dart';
import '../bindings/ride_binding.dart';
import '../bindings/ride_booking_binding.dart';
import '../bindings/ride_list_binding.dart';
import '../bindings/ride_tracking_binding.dart';
import '../pages/rides_list_page.dart';

class RideRoutes {
  static final routes = [
    GetPage(
      name: '/ride/list',
      page: () => const RidesListPage(),
      binding: RideListBinding(),
      middlewares: [AuthMiddleware()],
      bindings: [RideBinding()],
    ),
    GetPage(
      name: '/ride/details/:id',
      page: () => const Scaffold(body: Center(child: Text('Ride Details'))),
      binding: RideBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ride/booking/:id',
      page: () => const Scaffold(body: Center(child: Text('Book Ride'))),
      binding: RideBookingBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ride/tracking/:id',
      page: () => const Scaffold(body: Center(child: Text('Track Ride'))),
      binding: RideTrackingBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/ride/history',
      page: () => const Scaffold(body: Center(child: Text('Ride History'))),
      binding: RideBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}