import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:hiswana_migas/features/home/presentation/bloc/user/user_bloc.dart';

class FlipCardWidget extends StatelessWidget {
  const FlipCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureFlipCard(
      enableController: false,
      frontWidget: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = constraints.maxWidth * 0.9;
          double cardHeight = 580;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              height: cardHeight,
              width: cardWidth,
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoaded) {
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 90,
                                    backgroundImage: NetworkImage(
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
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(state.user.uniqueNumber,
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
          double cardWidth = constraints.maxWidth * 0.9;
          double cardHeight = 580;

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
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Copyright  2024 HISWANA MIGAS SEMARANG',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
