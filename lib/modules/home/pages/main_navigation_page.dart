import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/NavigationController.dart';
import 'home_page.dart';
import '../../load/pages/loads_list_page.dart';
import '../../ride/pages/rides_list_page.dart';
import '../../profile/pages/profile_page.dart';

class MainNavigationPage extends GetView<NavigationController> {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          const HomePage(),
          const LoadsListPage(),
          _buildComingSoonPage(
            'Booked Vehicles',
            'View your booked vehicles and trips',
            Icons.local_shipping_rounded,
            const Color(0xFF059669),
          ),
          _buildComingSoonPage(
            'Profile',
            'Manage your account and settings',
            Icons.person_rounded,
            const Color(0xFF7C3AED),
          ),
        ],
      )),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildComingSoonPage(String title, String subtitle, IconData icon, Color color) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE2E8F0).withOpacity(0.3),
                  const Color(0xFFE2E8F0),
                  const Color(0xFFE2E8F0).withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
        // Subtle background pattern
        Positioned.fill(
        child: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
    ),
    ),
    SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    child: ConstrainedBox(
    constraints: BoxConstraints(
    minHeight: MediaQuery.of(Get.context!).size.height -
    MediaQuery.of(Get.context!).padding.top -
    MediaQuery.of(Get.context!).padding.bottom -
    kToolbarHeight - 100,
    ),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    // Animated icon with ripple effect
    TweenAnimationBuilder<double>(
    duration: const Duration(milliseconds: 1500),
    tween: Tween(begin: 0.0, end: 1.0),
    curve: Curves.easeOutBack,
    builder: (context, value, child) {
    return Transform.scale(
    scale: 0.8 + 0.2 * value,
    child: Container(
    width: 160,
    height: 160,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
    colors: [
    color.withOpacity(0.2),
    color.withOpacity(0.1),
    Colors.transparent,
    ],
    stops: const [0.0, 0.7, 1.0],
    ),
    boxShadow: [
    BoxShadow(
    color: color.withOpacity(0.25),
    blurRadius: 20,
    offset: const Offset(0, 6),
    ),
    ],
    ),
    child: Container(
    margin: const EdgeInsets.all(24),
    decoration: BoxDecoration(
    color: Colors.white,
    shape: BoxShape.circle,
    border: Border.all(
    color: color.withOpacity(0.3),
    width: 2.5,
    ),
    boxShadow: [
    BoxShadow(
    color: color.withOpacity(0.15),
    blurRadius: 12,
    offset: const Offset(0, 4),
    ),
    ],
    ),
    child: Icon(
    icon,
    size: 56,
    color: color,
    ),
    ),
    ),
    );
    },
    ),

    const SizedBox(height: 48),

    // Enhanced