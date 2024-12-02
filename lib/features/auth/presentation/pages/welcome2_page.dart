import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Welcome2Page extends StatelessWidget {
  const Welcome2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset('assets/logo biru.png', width: 100),
            Text(
              'HISWANA MIGAS',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                context.pushNamed('login');
              },
              child: const Text('Log In'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
              onPressed: () {
                context.pushNamed('register');
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
