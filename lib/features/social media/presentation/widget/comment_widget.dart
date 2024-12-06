// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/features/home/presentation/bloc/user/user_bloc.dart';
import 'package:hiswana_migas/features/social%20media/data/models/comment_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/del_comment/delete_comment_cubit.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/reply/reply_bloc.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/comments/comments_bloc.dart';
import 'package:hiswana_migas/features/social%20media/presentation/widget/form_comment_widget.dart';
import 'package:hiswana_migas/utils/toast_helper.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsWidget extends StatefulWidget {
  final int postId;

  const CommentsWidget({super.key, required this.postId});

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final TextEditingController postCommentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CommentsBloc>(context).add(GetComments(widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(
      builder: (context, state) {
        if (state is CommentLoaded) {
          if (state.getComments.isEmpty) {
            return Stack(
              children: [
                DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.6,
                  maxChildSize: 0.95,
                  minChildSize: 0.4,
                  builder: (_, scrollController) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(
                          'Tidak ada komentar.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 0,
                  right: 0,
                  child: CommentInput(
                    controller: postCommentController,
                    onSend: () {
                      if (postCommentController.text.isNotEmpty) {
                        final comment = CommentModel(
                          content: postCommentController.text,
                          postId: widget.postId,
                        );
                        BlocProvider.of<CommentsBloc>(context).add(AddComment(
                          postId: widget.postId,
                          comment: comment,
                        ));

                        showToast(message: 'Komentar berhasil dibuat');
                        postCommentController.clear();
                      } else {
                        showToast(message: 'Komentar tidak boleh kosong');
                      }
                    },
                  ),
                ),
              ],
            );
          }

          final sortedComments = List<DetailComment>.from(state.getComments)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return Stack(
            children: [
              DraggableScrollableSheet(
                expand: false,
                initialChildSize: sortedComments.length > 6 ? 0.95 : 0.6,
                maxChildSize: 0.95,
                minChildSize: 0.4,
                builder: (_, scrollController) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Komentar',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: sortedComments.length,
                                  itemBuilder: (context, index) {
                                    final comment = sortedComments[index];
                                    return Column(
                                      children: [
                                        _buildCommentItem(context, comment),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: CommentInput(
                  controller: postCommentController,
                  onSend: () {
                    if (postCommentController.text.isNotEmpty) {
                      final comment = CommentModel(
                        content: postCommentController.text,
                        postId: widget.postId,
                      );

                      BlocProvider.of<CommentsBloc>(context).add(AddComment(
                        postId: widget.postId,
                        comment: comment,
                      ));

                      showToast(message: 'Komentar berhasil dibuat');
                      postCommentController.clear();
                    } else {
                      showToast(message: 'Komentar tidak boleh kosong');
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.95,
            minChildSize: 0.4,
            builder: (_, scrollController) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildCommentItem(BuildContext context, DetailComment comment) {
    final replies = comment.replies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          isThreeLine: true,
          leading: comment.user.profilePhoto == 'default.jpg'
              ? const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/user.jpg'),
                )
              : CachedNetworkImage(
                  imageUrl: '${dotenv.env['APP_URL']}${comment.user.profilePhoto}',
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
            comment.user.name,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              Text(
                timeago.format(comment.createdAt, locale: 'id'),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
              InkWell(
                onTap: () {
                  _showReplyDialog(context, comment);
                },
                child: Text(
                  'balas',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).primaryColor),
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
              if (value == 'hapus') {
                context.read<DeleteCommentCubit>().deleteComment(comment.id);
                BlocProvider.of<CommentsBloc>(context)
                    .add(GetComments(widget.postId));
                showToast(message: 'Komentar berhasil dihapus');
              }
            },
            itemBuilder: (context) {
              final user = (context.read<UserBloc>().state as UserLoaded).user;
              return [
                if (user.name == comment.user.name)
                  PopupMenuItem<String>(
                    value: 'hapus',
                    onTap: () async {
                      await context
                          .read<DeleteCommentCubit>()
                          .deleteComment(comment.id);
                      showToast(message: 'Komentar dihapus');
                      BlocProvider.of<CommentsBloc>(context).add(GetComments(
                        widget.postId,
                      ));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 20,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Hapus',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                  ),
              ];
            },
          ),
        ),
        if (replies!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: ExpansionTile(
              minTileHeight: 30,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              visualDensity: VisualDensity.compact,
              shape: const RoundedRectangleBorder(
                side: BorderSide.none,
              ),
              showTrailingIcon: false,
              initiallyExpanded: replies.length == 1,
              title: Text(
                replies.length == 1
                    ? 'Lihat balasan'
                    : 'Lihat ${replies.length} balasan',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              children: replies.map<Widget>((reply) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  isThreeLine: true,
                  leading: reply.user.profilePhoto == 'default.jpg'
                      ? const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/user.jpg'),
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              '${dotenv.env['APP_URL']}${reply.user.profilePhoto}',
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 20,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.error),
                          ),
                        ),
                  title: Text(
                    reply.user.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reply.content,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        timeago.format(reply.createdAt, locale: 'id'),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      InkWell(
                        onTap: () {
                          _showReplyDialog(context, comment);
                        },
                        child: Text(
                          'balas',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _showReplyDialog(BuildContext context, DetailComment comment) {
    final commentId = comment.id;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Balas Komentar'),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(
                hintText: 'Tulis balasan Anda untuk ${comment.user.name}'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (replyController.text.isNotEmpty) {
                  final comment = CommentModel(
                    content: replyController.text,
                  );
                  BlocProvider.of<ReplyBloc>(context).add(ReplyComment(
                    postId: widget.postId,
                    commentId: commentId,
                    comment: comment,
                  ));

                  BlocProvider.of<CommentsBloc>(context)
                      .add(GetComments(widget.postId));

                  showToast(message: 'Komentar berhasil dibuat');
                  replyController.clear();
                  context.pop();
                } else {
                  showToast(message: 'Komentar tidak boleh kosong');
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }
}
