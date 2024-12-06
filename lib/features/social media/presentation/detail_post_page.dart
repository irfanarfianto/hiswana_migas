import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/features/home/presentation/bloc/user/user_bloc.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/likes/likes_cubit.dart';
import 'package:hiswana_migas/features/social%20media/presentation/widget/comment_widget.dart';
import 'package:hiswana_migas/features/social%20media/presentation/widget/delete_confirm.dart';
import 'package:hiswana_migas/utils/toast_helper.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailPostPage extends StatefulWidget {
  final DetailPostEntity post;
  const DetailPostPage({super.key, required this.post});

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Jangan melakukan inisialisasi ulang 'post' di sini
    // Pastikan tidak ada inisialisasi ulang setelah widget dipanggil
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Detail Postingan'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              isThreeLine: true,
              leading: post.user.profilePhoto == 'default.jpg'
                  ? const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/user.jpg'),
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          '${dotenv.env['APP_URL']}${post.user.profilePhoto}',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 20,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.error),
                      ),
                    ),
              title: Text(
                post.user.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.user.uniqueNumber,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  Text(
                    timeago.format(
                      DateTime.parse('${post.createdAt}').toLocal(),
                      locale: 'id',
                    ),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                  } else if (value == 'hapus') {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          DeleteConfirmationDialog(postId: post.id),
                    );
                  } else if (value == 'bagikan') {
                    // TODO: tambahkan fungsi bagikan
                  }
                },
                itemBuilder: (context) {
                  final user =
                      (context.read<UserBloc>().state as UserLoaded).user;
                  return [
                    if (user.uniqueNumber == post.user.uniqueNumber)
                      PopupMenuItem<String>(
                        onTap: () => context.pushNamed(
                          'edit-post',
                          extra: post,
                        ),
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            const SizedBox(width: 5),
                            const Text('Edit'),
                          ],
                        ),
                      ),
                    if (user.uniqueNumber == post.user.uniqueNumber)
                      PopupMenuItem<String>(
                        value: 'hapus',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 20,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 5),
                            const Text('Hapus'),
                          ],
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: 'bagikan',
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          const SizedBox(width: 5),
                          const Text('Bagikan'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ),
            if (post.photos.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: post.photos.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                context.pushNamed(
                                  'detail-post',
                                  extra: post,
                                );
                              },
                              child: ClipRRect(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${dotenv.env['APP_URL']}${post.photos[index]}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            if (post.photos.length > 1)
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${index + 1}/${post.photos.length}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            if (post.photos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ReadMoreText(
                  textAlign: TextAlign.start,
                  post.caption ?? '',
                  trimLines: 3,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  trimMode: TrimMode.Line,
                  colorClickableText: Theme.of(context).colorScheme.onSecondary,
                  trimCollapsedText: 'Selengkapnya',
                  trimExpandedText: 'Sembunyikan',
                  moreStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                ),
              ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<LikesCubit, LikesState>(
                    builder: (context, state) {
                      bool isLiked = false;
                      if (state is PostLikeLoaded && state.postId == post.id) {
                        isLiked = state.isLiked;
                      }
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<LikesCubit>().postLike(post.id);
                              if (isLiked) {
                                showToast(message: 'Batal menyukai');
                              } else {
                                showToast(message: 'Menyukai');
                              }
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: 35,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                isScrollControlled: true,
                                builder: (context) => CommentsWidget(
                                  postId: post.id,
                                ),
                              );
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.comment,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${post.likes.length} suka',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (post.photos.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(post.caption ?? '',
                          style: Theme.of(context).textTheme.bodyMedium)),
                if (post.comments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          builder: (context) => CommentsWidget(
                            postId: post.id,
                          ),
                        );
                      },
                      child: Text(
                        'Lihat semua ${post.comments.length} komentar',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
