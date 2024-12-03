import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/features/social%20media/presentation/widget/comment_widget.dart';
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
              leading: InkWell(
                onTap: () {},
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/user.jpg'),
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
            if (post.photos.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  itemCount: post.photos.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      child: Image.asset(
                        'assets/user.jpg',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
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
