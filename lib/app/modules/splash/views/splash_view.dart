import 'package:fan_poll/app/utills/image_path.dart';
import 'package:fan_poll/app/utills/color.dart';
import 'package:fan_poll/app/utills/localStorageService.dart';
import 'package:fan_poll/app/utills/url_handler_service.dart';
import 'package:fan_poll/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    if (initialDeepLink != null) {
      print('SplashView: Deep link detected, navigating directly to shared poll');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleDeepLink();
      });
    } else {
      _startAnimations();
      _navigateAfterDelay();
    }
  }

  Future<void> _handleDeepLink() async {
    final deepLinkUrl = initialDeepLink;
    initialDeepLink = null;
    try {
      await Get.find<UrlHandlerService>().handleSharedUrl(deepLinkUrl!);
    } catch (e) {
      print('Error handling deep link: $e');
      Get.offAllNamed('/login');
    }
  }

  void _startAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    print('SplashView: Animation complete, checking if deep link is being processed');
    
    if (initialDeepLink != null) {
      print('SplashView: Deep link still active, deep link handler will take over');
      return;
    }

    print('SplashView: No deep link, checking authentication status');
    try {
      final token = await LocalStorageService.getString('token');
      if (token != null && token.isNotEmpty) {
        print('SplashView: User logged in, navigating to home');
        Get.offAllNamed('/main');
      } else {
        print('SplashView: User not logged in, navigating to login');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print('SplashView: Error checking token: $e');
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.WhiteColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              AssetPath.Logo,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
