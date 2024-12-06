import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/domain/entities/detail_post_entity.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/post/post_bloc.dart';
import 'package:hiswana_migas/utils/toast_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPostPage extends StatefulWidget {
  final DetailPostEntity post;
  const EditPostPage({super.key, required this.post});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final TextEditingController contentController = TextEditingController();
  final List<XFile?> _images = [];
  final List<String> _deletedImages = []; // To track images that are deleted
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    contentController.text = widget.post.caption ?? '';
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

  void _removeImage(int index) {
    setState(() {
      final image = _images[index];
      if (image != null) {
        // If it's a server image, track it for deletion on the server
        if (widget.post.photos.contains(image.path)) {
          _deletedImages.add(image.path); // Track image to delete from server
        }
        _images.removeAt(index);
      }
    });
  }

  void _submitPost() {
    if (contentController.text.isEmpty && _images.isEmpty) {
      showToast(message: "Caption atau foto harus diisi");
      return;
    }

    // Pisahkan foto lokal dan foto dari server
    final localImages = _images
        .where((image) => !widget.post.photos.contains(image?.path))
        .map((e) => e!.path)
        .toList();
    final serverImages = widget.post.photos; // Gambar yang sudah ada di server

    // Hanya kirim gambar lokal yang baru
    final postCreate = PostModel(
      caption: contentController.text.isNotEmpty ? contentController.text : '',
      photo: [
        ...serverImages, // Gambar server tidak perlu dikirim ulang
        ...localImages // Kirim hanya gambar lokal yang baru
      ],
    );

    debugPrint("Payload before sending: ${postCreate.toJson()}");

    try {
      BlocProvider.of<PostBloc>(context)
          .add(UpdatePostEvent(postId: widget.post.id, updatePost: postCreate));
      context.pop();
      showToast(message: "Postingan berhasil diperbarui");
    } on Exception {
      showToast(message: "Gagal memperbarui postingan");
    }
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
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      // Check if the image is from the server or local
                      if (widget.post.photos.contains(image?.path)) {
                        return Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  '${dotenv.env['APP_URL']}${image!.path}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        );
                      }
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
