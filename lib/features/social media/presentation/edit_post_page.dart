// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/utils/toast_helper.dart';
import 'package:image_picker/image_picker.dart';

class EditPostPage extends StatefulWidget {
  final DetailPostEntity post;
  const EditPostPage({super.key, required this.post});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final TextEditingController contentController = TextEditingController();
  final List<XFile?> _images = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan caption yang ada
    contentController.text = widget.post.caption ?? '';
    // Inisialisasi gambar dengan gambar yang ada
    if (widget.post.photos.isNotEmpty) {
      _images.addAll(widget.post.photos.map((e) => XFile(e)).toList());
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    XFile? image;
    if (source == ImageSource.camera) {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null) {
        setState(() {
          _images.addAll(images);
        });
        return;
      }
    }

    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  void _submitPost() {
    if (contentController.text.isEmpty && _images.isEmpty) {
      showToast(message: "Caption atau foto harus diisi");
      return;
    }

    final postCreate = PostModel(
      caption: contentController.text.isNotEmpty ? contentController.text : '',
      photo: _images.isNotEmpty ? _images.map((e) => e!.path).toList() : [],
    );

    debugPrint("Payload before sending: ${postCreate.toJson()}");
    // BlocProvider.of<PostBloc>(context)
    //     .add(UpdatePostEvent(postId: widget.post.id, postCreate: postCreate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Edit Postingan'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text('Perbarui Postingan'),
              trailing: SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _submitPost,
                  label: const Text('Perbarui'),
                  icon: const FaIcon(FontAwesomeIcons.paperPlane),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                hintText: 'Konten Postingan',
              ),
              maxLines: 5,
              maxLength: 500,
            ),
            const SizedBox(height: 10),
            _images.isEmpty
                ? const Text('Tidak ada gambar yang dipilih')
                : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: _images.length > 6 ? 6 : _images.length,
                    itemBuilder: (context, index) {
                      if (_images.length > 6 && index == 5) {
                        return Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  '${dotenv.env['APP_URL']}${_images[index]!.path}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            Center(
                              child: Text(
                                '+ ${_images.length - 6}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        );
                      }
                      return CachedNetworkImage(
                        imageUrl:
                            '${dotenv.env['APP_URL']}${_images[index]!.path}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Tambahkan dipostingan mu :'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () => _pickImages(ImageSource.gallery),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_enhance),
                  onPressed: () => _pickImages(ImageSource.camera),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
