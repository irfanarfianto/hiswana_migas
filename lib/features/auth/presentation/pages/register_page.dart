import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF05A0F8),
            Color(0xFF015381),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Sign Up',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white)),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Isi biodata anda',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.surface),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(50)),
                        width: 50,
                        height: 5,
                      ),
                      const SizedBox(height: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Masukkan Nama Lengkap',
                              ),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Provinsi',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Pilih Provinsi',
                              ),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kota',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Pilih Kota',
                              ),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Masukkan Email',
                              ),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kata Sandi',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan Kata Sandi',
                              ),
                            ),
                          ]),
                      const SizedBox(height: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Foto Profil',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 5),
                            TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Upload Foto Profil',
                              ),
                            ),
                          ]),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {},
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              const TextSpan(text: 'Sudah punya akun? '),
                              TextSpan(
                                text: 'Masuk disini',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.push('/login');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
