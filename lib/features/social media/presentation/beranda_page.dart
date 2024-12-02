import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/features/social%20media/presentation/widget/comment_widget.dart';
import 'package:readmore/readmore.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
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
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/user.jpg'),
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      context.pushNamed('create-post');
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            context.pushNamed('detail-post');
                          },
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '33 77 0001',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                              ),
                              Text(
                                'Waktu posting',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
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
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Hapus',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error),
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.pushNamed('detail-post');
                          },
                          child: ClipRRect(
                            child: Image.asset(
                              'assets/user.jpg',
                              height: MediaQuery.of(context).size.width,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '100 Suka',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ReadMoreText(
                                'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                                trimLines: 2,
                                trimMode: TrimMode.Line,
                                colorClickableText:
                                    Theme.of(context).colorScheme.onSecondary,
                                trimCollapsedText: 'Selengkapnya',
                                trimExpandedText: 'Sembunyikan',
                                moreStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    showDragHandle: true,
                                    isScrollControlled: true,
                                    builder: (context) =>
                                        const CommentsWidget(),
                                  );
                                },
                                child: Text(
                                  'Lihat semua 10 komentar',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
