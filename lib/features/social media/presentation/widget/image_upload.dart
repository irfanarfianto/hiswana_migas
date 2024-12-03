import 'package:flutter/material.dart';

class ImageUploadWidget extends StatefulWidget {
  const ImageUploadWidget({super.key});

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = BottomSheet.createAnimationController(this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.maxFinite),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Unggah Gambar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text('Galeri'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Kamera'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
      animationController: _animationController,
    );
  }
}
