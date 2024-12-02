import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        body: SingleChildScrollView(
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
                            'John Doe',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/user.jpg'),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('beranda');
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    height: 580,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/bg-card-depan.png'),
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
                            Image.asset('assets/logo_putih.png', width: 80),
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
                            Image.asset('assets/circle user.png', width: 250),
                            Positioned(
                              top: 92,
                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    radius: 90,
                                    backgroundImage: AssetImage(
                                      'assets/user.jpg',
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'John Doe',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('No. Anggota',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
