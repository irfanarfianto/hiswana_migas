import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiswana_migas/features/social%20media/presentation/widget/comment_widget.dart';

class DetailPostPage extends StatefulWidget {
  const DetailPostPage({super.key});

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Detail Postingan'),
        ),
        body: Column(
          children: [
            ListTile(
              isThreeLine: true,
              leading: InkWell(
                onTap: () {},
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/user.jpg'),
                ),
              ),
              title: Text(
                'Nama User',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '33 77 0001',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  Text(
                    'Waktu posting',
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
            ClipRRect(
              child: Image.asset(
                'assets/user.jpg',
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.comment,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '100 Suka',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                        style: Theme.of(context).textTheme.bodyMedium)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        isScrollControlled: true,
                        builder: (context) => const CommentsWidget(),
                      );
                    },
                    child: Text(
                      'Lihat semua 10 komentar',
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
