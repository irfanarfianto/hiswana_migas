import 'package:flutter/material.dart';

class CommentsWidget extends StatefulWidget {
  const CommentsWidget({super.key});

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final List<Map<String, dynamic>> comments = [
    {
      'user': 'User 1',
      'comment': 'Komentar pertama!',
      'time': '1 jam yang lalu',
      'replies': [
        {
          'user': 'User 2',
          'comment': 'Balasan pertama!',
          'time': '50 menit lalu'
        },
        {
          'user': 'User 3',
          'comment': 'Balasan kedua!',
          'time': '30 menit lalu'
        },
        {
          'user': 'User 5',
          'comment': 'Balasan kelima!',
          'time': '10 menit lalu'
        },
      ]
    },
    {
      'user': 'User 4',
      'comment': 'Komentar kedua!',
      'time': '2 jam yang lalu',
      'replies': [
        {
          'user': 'User 2',
          'comment': 'Balasan pertama!',
          'time': '50 menit lalu'
        },
      ],
    },
  ];

  void _addReply(int commentIndex, String reply) {
    setState(() {
      comments[commentIndex]['replies'].add({
        'user': 'User Anda',
        'comment': reply,
        'time': 'Baru saja',
      });
    });
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
                  _addReply(commentIndex, replyController.text);
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

  @override
  Widget build(BuildContext context) {
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
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _buildCommentItem(context, comment, index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentItem(
      BuildContext context, Map<String, dynamic> comment, int commentIndex) {
    final replies = comment['replies'] as List<dynamic>;
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
            comment['user'],
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment['comment'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              Text(
                comment['time'],
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
                    reply['user'],
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reply['comment'],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        reply['time'],
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
}
