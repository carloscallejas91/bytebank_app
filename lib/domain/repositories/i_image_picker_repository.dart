import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class IImagePickerRepository {
  Future<File?> pickImage(ImageSource source);
}
