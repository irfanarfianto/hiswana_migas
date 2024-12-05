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
  bool _isPasswordHidden = true;

  final _formKey = GlobalKey<FormState>();

  String? selectedProvinsi;
  String? selectedKota;
  File? profileImage;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = file.lengthSync();

        const int maxFileSize = 2 * 1024 * 1024;
        if (fileSize > maxFileSize) {
          showToast(
              message: 'Ukuran gambar melebihi 2MB. Silakan pilih file lain.');
          return;
        }

        setState(() {
          profileImage = file;
        });
      }
    } catch (e) {
      showToast(message: 'Gagal memilih gambar');
    }
  }

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
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
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
                showDialog(
                  context: context,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is AuthError) {
                context.pop();
                showToast(message: 'Gagal registrasi');
              } else if (state is RegisterSuccess) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registrasi Sukses!')),
                );

                context.push('/login');
              }
            },
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Isi biodata anda',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
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
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nama',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: nameController,
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
                            const SizedBox(height: 20),
                            BlocBuilder<ProvinsiBloc, ProvinsiState>(
                              builder: (context, state) {
                                if (state is ProvinsiLoaded) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Provinsi',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
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
                                                .add(GetKota(
                                                    provinsiCode: value));
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
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Provinsi',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(height: 5),
                                      DropdownButtonFormField<String>(
                                        value: selectedProvinsi,
                                        icon: const SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            )),
                                        decoration: const InputDecoration(
                                          hintText: 'Pilih Provinsi',
                                        ),
                                        items: const [],
                                        onChanged: null,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
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
                                          value: selectedKota,
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
                            const SizedBox(height: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
                            const SizedBox(height: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kata Sandi',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: passwordController,
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
                                            _isPasswordHidden =
                                                !_isPasswordHidden;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: validatePassword,
                                  ),
                                ]),
                            const SizedBox(height: 20),
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
                                  obscureText: _isPasswordHidden,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan Konfirmasi Kata Sandi',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordHidden =
                                              !_isPasswordHidden;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Konfirmasi kata sandi wajib diisi';
                                    } else if (value !=
                                        passwordController.text) {
                                      return 'Konfirmasi kata sandi tidak cocok';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Foto Profil',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: _pickImage,
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
                                  profileImage != null
                                      ? Image.file(profileImage!, height: 100)
                                      : const SizedBox(),
                                ]),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(RegisterEvent(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    confirmPassword:
                                        confirmPasswordController.text,
                                    provinceCode: selectedProvinsi ?? '',
                                    cityCode: selectedKota ?? '',
                                    profilePhoto: profileImage,
                                  ));
                                }
                              },
                              child: const Text('Daftar'),
                            ),
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
      ),
    );
  }
}
