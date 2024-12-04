import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/comment_entity.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/comments/comments_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsWidget extends StatefulWidget {
  final int postId;

  const CommentsWidget({super.key, required this.postId});

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
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
          // Jika komentar kosong, tampilkan pesan bahwa tidak ada komentar
          if (state.comments.isEmpty) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.4,
              maxChildSize: 0.6,
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
            );
          }

          // Jika ada komentar, tampilkan komentar seperti biasa
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 1,
            minChildSize: 0.4,
            builder: (_, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Komentar',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) {
                          final comment = state.comments[index];
                          return _buildCommentItem(context, comment, index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.4,
            maxChildSize: 0.6,
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

  Widget _buildCommentItem(
      BuildContext context, Comment comment, int commentIndex) {
    final replies = comment.replies;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          isThreeLine: true,
          leading: const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/user.jpg'),
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
                timeago.format(comment.createdAt),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
              InkWell(
                onTap: () {
                  _showReplyDialog(context, commentIndex);
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
              if (value == 'edit') {
                // implement edit comment
              } else if (value == 'hapus') {
                // implement delete comment
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(
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

        // ExpansionTile untuk balasan
        if (replies.isNotEmpty)
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
                  leading: const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/user.jpg'),
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
                        timeago.format(reply.createdAt),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary),
                      ),
                      InkWell(
                        onTap: () {
                          _showReplyDialog(context, commentIndex);
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

  void _showReplyDialog(BuildContext context, int commentIndex) {
    final TextEditingController replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Balas Komentar'),
          content: TextField(
            controller: replyController,
            decoration: const InputDecoration(hintText: 'Tulis balasan Anda'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (replyController.text.isNotEmpty) {
                  // implement add reply
                }
                Navigator.pop(context);
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }
}
