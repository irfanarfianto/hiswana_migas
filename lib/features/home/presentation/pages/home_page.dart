// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/home/presentation/bloc/user/user_bloc.dart';
import 'package:hiswana_migas/utils/toast_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TokenLocalDataSource tokenLocalDataSource;

  @override
  void initState() {
    super.initState();
    const storage = FlutterSecureStorage();
    tokenLocalDataSource = TokenLocalDataSource(storage);
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final token = await tokenLocalDataSource.getToken();
      if (token != null && token.isNotEmpty && mounted) {
        BlocProvider.of<UserBloc>(context).add(GetUserEvent(token: token));
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    TextButton(
                      onPressed: () {
                        _loadUserInfo();
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }
            if (state is UserLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 50),
                          color: Theme.of(context).primaryColor,
                          child: Row(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  state.user.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                )
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Konfirmasi Logout'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin keluar?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.pop();
                                            tokenLocalDataSource.deleteToken();
                                            context.go('/welcome2');
                                          },
                                          child: const Text('Logout'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showToast(message: 'Coming Soon');
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  '${dotenv.env['APP_URL']}${state.user.profilePhoto}',
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Positioned(
                            bottom: -50,
                            child: Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width - 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showToast(message: 'Coming Soon');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.wallet),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Dashboard',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        context.pushNamed('beranda');
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.history),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Social Media',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Text(
                        'Kartu Anggota',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Center(
                      child: GestureFlipCard(
                        enableController: false,
                        frontWidget: LayoutBuilder(
                          builder: (context, constraints) {
                            // Menetapkan ukuran tetap berdasarkan constraints
                            double cardWidth = constraints.maxWidth *
                                0.9; // 90% dari lebar parent
                            double cardHeight = 580; // Tinggi tetap

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                height: cardHeight,
                                width: cardWidth,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image:
                                        AssetImage('assets/bg-card-depan.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset('assets/logo_putih.png',
                                            width: 80),
                                        const SizedBox(height: 5),
                                        Text(
                                          'HISWANA MIGAS\nSEMARANG',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset('assets/circle user.png',
                                            width: 250),
                                        Positioned(
                                          top: 92,
                                          child:
                                              BlocBuilder<UserBloc, UserState>(
                                            builder: (context, state) {
                                              if (state is UserLoaded) {
                                                return Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 90,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        '${dotenv.env['APP_URL']}${state.user.profilePhoto}',
                                                      ),
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Text(
                                                      state.user.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                        state.user.uniqueNumber,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium),
                                                  ],
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        backWidget: LayoutBuilder(
                          builder: (context, constraints) {
                            // Menetapkan ukuran tetap berdasarkan constraints
                            double cardWidth = constraints.maxWidth *
                                0.9; // 90% dari lebar parent
                            double cardHeight = 580; // Tinggi tetap

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                height: cardHeight,
                                width: cardWidth,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage('assets/belakang.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/girhub.png',
                                      width: 180,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Sistem Informasi\nHISWANA MIGAS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Copyright  2024 HISWANA MIGAS SEMARANG',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            }
            {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
