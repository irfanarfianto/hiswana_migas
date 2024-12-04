// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/core/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late TokenLocalDataSource _tokenLocalDataSource;

  @override
  void initState() {
    super.initState();
    _tokenLocalDataSource = TokenLocalDataSource(const FlutterSecureStorage());
    _navigateToNextPage();
  }

  void _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final token = await _tokenLocalDataSource.getToken();

    if (token == null || token.isEmpty) {
      context.pushReplacementNamed('welcome1');
    } else {
      context.pushReplacementNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo_putih.png', width: 200),
            Text(
              'HISWANA MIGAS',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
