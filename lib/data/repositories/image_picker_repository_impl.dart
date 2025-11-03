import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/domain/repositories/i_image_picker_repository.dart';

class ImagePickerRepositoryImpl implements IImagePickerRepository {
  final ImagePicker _picker;

  ImagePickerRepositoryImpl({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  @override
  Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
