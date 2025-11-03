import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/domain/repositories/i_image_picker_repository.dart';

class PickImageUseCase {
  final IImagePickerRepository _repository;

  PickImageUseCase(this._repository);

  Future<File?> call(ImageSource source) {
    return _repository.pickImage(source);
  }
}
