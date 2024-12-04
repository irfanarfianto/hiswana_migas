import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/core/token_storage.dart';
import 'package:hiswana_migas/features/home/presentation/bloc/user/user_bloc.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/post/post_bloc.dart';
import 'package:hiswana_migas/features/social%20media/presentation/widget/image_upload.dart';
import 'package:hiswana_migas/features/social%20media/presentation/widget/post_widget.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
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
        BlocProvider.of<PostBloc>(context).add(GetPostsEvent());
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text('Beranda'),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _loadUserInfo();
          },
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserLoaded) {
                        return InkWell(
                          onTap: () {
                            context.pushNamed('profile');
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: state.user.profilePhoto != null
                                ? NetworkImage(
                                    '${dotenv.env['APP_URL']}${state.user.profilePhoto!}')
                                : const AssetImage('assets/user.jpg'),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      context.pushNamed('create-post').then((refresh) {
                        if (refresh is bool && refresh) {
                          setState(() {
                            _loadUserInfo();
                          });
                        }
                      });
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(50),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 35,
                        child: Text(
                          'Diskusi hari ini',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    icon: Icon(
                      Icons.add_photo_alternate_rounded,
                      color: Theme.of(context).colorScheme.onSecondary,
                      size: 35,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        isScrollControlled: true,
                        builder: (context) => const ImageUploadWidget(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PostError) {
                  return Center(child: Text(state.message));
                }
                if (state is PostLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return PostWidget(post: post);
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ]),
        ),
      ),
    );
  }
}
