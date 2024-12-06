// ignore_for_file: library_private_types_in_public_api, unnecessary_nullable_for_final_variable_declarations

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hiswana_migas/features/social%20media/data/models/post_model.dart';
import 'package:hiswana_migas/features/social%20media/presentation/bloc/post/post_bloc.dart';
import 'package:hiswana_migas/utils/toast_helper.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController contentController = TextEditingController();
  final List<XFile?> _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages(ImageSource source) async {
    if (_images.length >= 8) {
      showToast(message: 'Maksimal 8 gambar yang dapat diunggah');
      return;
    }

    try {
      XFile? image;
      if (source == ImageSource.camera) {
        image = await _picker.pickImage(source: ImageSource.camera);
      } else {
        final List<XFile>? images = await _picker.pickMultiImage();
        if (images != null) {
          for (var img in images) {
            final file = File(img.path);
            if (await file.length() <= 2 * 1024 * 1024) {
              setState(() {
                final int remainingSlots = 8 - _images.length;
                if (remainingSlots > 0) {
                  _images.add(img);
                }
              });
            } else {
              showToast(message: 'Ukuran gambar tidak boleh lebih dari 2MB');
            }
          }
          return;
        }
      }

      if (image != null) {
        final file = File(image.path);
        if (await file.length() <= 2 * 1024 * 1024) {
          setState(() {
            _images.add(image);
          });
        } else {
          showToast(message: 'Ukuran gambar tidak boleh lebih dari 2MB');
        }
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'already_active') {
        showToast(message: 'Pilih gambar sedang aktif. Silakan coba lagi.');
      } else {
        showToast(message: 'Terjadi kesalahan');
      }
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
    BlocProvider.of<PostBloc>(context)
        .add(CreatePostEvent(postCreate: postCreate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Postingan'),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
          ),
        ),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostCreated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showToast(message: 'Berhasil');
              contentController.clear();
              _images.clear();

              GoRouter.of(context).pop(true);
            });
          } else if (state is PostError) {
            showToast(message: 'Error: ${state.message}');
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('Buat Postingan'),
                  trailing: SizedBox(
                    width: 130,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: _submitPost,
                      label: const Text('Posting'),
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
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(_images[index]!.path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _images.removeAt(index);
                                      });
                                    },
                                  )),
                            ],
                          );
                        },
                      )
              ],
            ),
          );
        },
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
