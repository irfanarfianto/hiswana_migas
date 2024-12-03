import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:hiswana_migas/features/auth/presentation/bloc/kota/kota_bloc.dart';
import 'package:hiswana_migas/features/auth/presentation/bloc/provkot/provinsi_bloc.dart';
import 'package:hiswana_migas/utils/toast_helper.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // init
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProvinsiBloc>(context).add(GetProvinsi());
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Add a key to the form

  String? selectedProvinsi;
  String? selectedKota;
  File? profileImage; // Variable to hold the profile image

  // Pick image using the image_picker package
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle the exception here, e.g., show a dialog or a snackbar
      print('An error occurred: $e');
    }
  }

  // Validate email format
  String? validateEmail(String? value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Validate password strength
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

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
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              // Tampilkan loading
              showDialog(
                context: context,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthError) {
              // Tampilkan pesan error
              context.pop();
              showToast(message: 'Gagal registrasi');
            } else if (state is RegisterSuccess) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registrasi Sukses!')),
              );
              // Navigasi ke halaman lain (misalnya halaman login atau home)
              context.push('/login');
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, // Wrap the form with GlobalKey<FormState>
                child: Column(
                  children: [
                    Text(
                      'Isi biodata anda',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.surface),
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
                          // Nama Field
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller:
                                      nameController, // Controller added
                                  decoration: const InputDecoration(
                                    hintText: 'Masukkan Nama Lengkap',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nama lengkap wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ]),

                          // Provinsi Dropdown
                          const SizedBox(height: 20),
                          BlocBuilder<ProvinsiBloc, ProvinsiState>(
                            builder: (context, state) {
                              if (state is ProvinsiLoaded) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Provinsi',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 5),
                                    DropdownButtonFormField<String>(
                                      value: selectedProvinsi,
                                      decoration: const InputDecoration(
                                        hintText: 'Pilih Provinsi',
                                      ),
                                      items: state.provinsi.map((provinsi) {
                                        return DropdownMenuItem(
                                          value: provinsi.code.toString(),
                                          child: Text(provinsi.name),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedProvinsi = value;
                                          selectedKota = null;
                                        });
                                        if (value != null) {
                                          BlocProvider.of<KotaBloc>(context)
                                              .add(
                                                  GetKota(provinsiCode: value));
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Provinsi wajib dipilih';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                );
                              } else if (state is ProvinsiLoading) {
                                return const CircularProgressIndicator();
                              } else {
                                return Container();
                              }
                            },
                          ),

                          // Kota Dropdown
                          const SizedBox(height: 20),
                          BlocBuilder<KotaBloc, KotaState>(
                            builder: (context, state) {
                              return IgnorePointer(
                                ignoring: selectedProvinsi == null,
                                child: Opacity(
                                  opacity: selectedProvinsi == null ? 0.5 : 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kota',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(height: 5),
                                      DropdownButtonFormField<String>(
                                        value:
                                            selectedKota, // Keep selected value
                                        decoration: const InputDecoration(
                                          hintText: 'Pilih Kota',
                                        ),
                                        items: state is KotaLoaded
                                            ? (state).kota.map((kota) {
                                                return DropdownMenuItem(
                                                  value: kota.code.toString(),
                                                  child: Text(kota.name),
                                                );
                                              }).toList()
                                            : [],
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedKota = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Kota wajib dipilih';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Email Field
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
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    hintText: 'Masukkan Email',
                                  ),
                                  validator: validateEmail,
                                ),
                              ]),

                          // Password Field
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
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Masukkan Kata Sandi',
                                  ),
                                  validator: validatePassword,
                                ),
                              ]),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Konfirmasi Kata Sandi',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan Konfirmasi Kata Sandi',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Konfirmasi kata sandi wajib diisi';
                                  } else if (value != passwordController.text) {
                                    return 'Konfirmasi kata sandi tidak cocok';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          // Profile Picture
                          const SizedBox(height: 20),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Foto Profil',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: _pickImage, // Trigger image picker
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Pilih Foto Profil',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Show selected image if exists
                                profileImage != null
                                    ? Image.file(profileImage!, height: 100)
                                    : const SizedBox(),
                              ]),
                          const SizedBox(height: 20),

                          // Register Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(RegisterEvent(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  provinceCode: selectedProvinsi ?? '',
                                  cityCode: selectedKota ?? '',
                                  profilePhoto: profileImage?.path ?? '',
                                ));
                              }
                            },
                            child: const Text('Daftar'),
                          ),

                          // Already have an account text
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text: 'Sudah punya akun? ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push('/login');
                                    },
                                ),
                              ],
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
        ),
      ),
    );
  }
}
