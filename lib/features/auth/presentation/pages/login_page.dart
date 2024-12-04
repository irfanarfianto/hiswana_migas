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
  final _formKey = GlobalKey<FormState>(); // Tambahkan GlobalKey untuk form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else {
          if (context.canPop()) {
            context.pop();
          }
          if (state is AuthAuthenticated) {
            context.pushNamed('home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
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
              child: Form(
                key: _formKey, // Tambahkan Form dan kunci
                child: SingleChildScrollView(
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Masukkan email yang valid';
                                }
                                return null;
                              },
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
                              obscureText: _isPasswordHidden,
                              decoration: InputDecoration(
                                hintText: 'Masukkan Kata Sandi',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordHidden = !_isPasswordHidden;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                if (value.length < 6) {
                                  return 'Kata sandi harus lebih dari 6 karakter';
                                }
                                return null;
                              },
                            ),
                          ]),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Lakukan login jika validasi berhasil
                            context.read<AuthBloc>().add(LoginEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ));
                          }
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
        ),
      ),
    );
  }
}
