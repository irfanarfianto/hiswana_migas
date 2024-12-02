import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Welcome1Page extends StatelessWidget {
  const Welcome1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/oil-prices-industry.png', width: 350),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Selamat Datang',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Di Aplikasi Kartu Tanda Anggota Digital\nHiswana Migas',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => context.pushNamed('welcome2'),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
