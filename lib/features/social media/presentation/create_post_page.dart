import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController contentController = TextEditingController();
  final List<XFile?> _images = []; // To store multiple selected images

  final ImagePicker _picker = ImagePicker();

  // Method to pick multiple images
  Future<void> _pickImages(ImageSource source) async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _images.addAll(images); // Add selected images to the list
      });
    }
  }

  void _submitPost() {
    if (contentController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Postingan berhasil dibuat')),
      );

      contentController.clear();
      setState(() {
        _images.clear(); // Clear the image list after posting
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konten tidak boleh kosong')),
      );
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
          title: const Text('Postingan'),
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
            // Display selected images

            _images.isEmpty
                ? const Text('Tidak ada gambar yang dipilih')
                : GalleryImage(
                    numOfShowImages: 6,
                    imageUrls: _images.map((image) => image!.path).toList(),
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
