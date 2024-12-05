import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/home/presentation/bloc/user/user_bloc.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TokenLocalDataSource tokenLocalDataSource =
        TokenLocalDataSource(const FlutterSecureStorage());

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      '${dotenv.env['APP_URL']}${state.user.profilePhoto}',
                    ),
                  ),
                  accountName: Text(state.user.name),
                  accountEmail: Text(state.user.email),
                ),
                ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  onTap: () {
                    _showLogoutDialog(context, tokenLocalDataSource);
                  },
                  textColor: Colors.red,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showLogoutDialog(
      BuildContext context, TokenLocalDataSource tokenLocalDataSource) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
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
  }

  void showToast({required String message}) {}
}
