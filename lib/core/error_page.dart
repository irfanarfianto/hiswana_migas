import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  final String? errorMessage;

  const ErrorPage({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                errorMessage ?? 'Terjadi kesalahan yang tidak terduga.',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  context.pop();
                },
                label: const Text('Kembali'),
                icon: const Icon(Icons.back_hand),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
