import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeAvatarSheet extends StatelessWidget {
  final ValueChanged<ImageSource> onPickImage; // Callback para a ação

  const ChangeAvatarSheet({super.key, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Tirar Foto'),
            onTap: () {
              Navigator.pop(context); // Fecha o sheet
              onPickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Escolher da Galeria'),
            onTap: () {
              Navigator.pop(context); // Fecha o sheet
              onPickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
