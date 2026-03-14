import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const LoginScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hub_outlined, size: 100, color: AppColors.accent),
            const SizedBox(height: 20),
            const Text(
              'OneHub',
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                letterSpacing: 2.0
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 150,
              child: LinearProgressIndicator(color: AppColors.accent, backgroundColor: AppColors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
