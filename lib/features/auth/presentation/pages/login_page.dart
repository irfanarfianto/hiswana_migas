import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/features/auth/presentation/bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print(state);
        if (state is AuthLoading) {
          // Tampilkan loading jika sedang proses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text('Logging in...'),
                ],
              ),
            ),
          );
        } else if (state is AuthAuthenticated) {
          // Navigasi ke halaman utama setelah login berhasil
          context.pushNamed('home');
        } else if (state is AuthError) {
          // Tampilkan pesan error jika login gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Container(
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
            title: Text('Login',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white)),
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _emailController,
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
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan Kata Sandi',
                          ),
                        ),
                      ]),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                    ),
                    onPressed: () {
                      // Kirim event login ke BLoC
                      context.read<AuthBloc>().add(LoginEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ));
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                    ),
                    onPressed: () {
                      context.push('/reset-password');
                    },
                    child: const Text('Reset Password'),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          const TextSpan(text: 'Belum punya akun? '),
                          TextSpan(
                            text: 'Masuk disini',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push('/register');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
