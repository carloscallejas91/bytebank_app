import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/get_cached_avatar_path_usecase.dart';
import 'package:mobile_app/domain/usecases/pick_image_usecase.dart';
import 'package:mobile_app/domain/usecases/save_avatar_usecase.dart';

class AvatarController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Repositories
  final _authRepository = Get.find<IAuthRepository>();

  // Use Cases
  final _saveAvatarUseCase = Get.find<SaveAvatarUseCase>();
  final _pickImageUseCase = Get.find<PickImageUseCase>();
  final _getCachedAvatarPathUseCase = Get.find<GetCachedAvatarPathUseCase>();

  // UI State para avatar
  final userPhotoUrl = ''.obs;
  final avatarImageProvider = Rxn<ImageProvider>();
  final isAvatarLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    _loadCachedAvatar();
    _setupListeners();
  }

  // UI Actions
  Future<void> pickAndSaveImage(ImageSource source) async {
    final localFile = await _pickImageUseCase.call(source);
    if (localFile == null) return;

    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      _snackBarService.showError(
        title: 'Erro',
        message: 'Usuário não autenticado.',
      );
      return;
    }
    await _saveAvatarAndUpdateUI(localFile, userId);
  }

  // Internal Logic & Private Methods
  void _setupListeners() {
    ever(userPhotoUrl, (_) => _updateAvatarImageProvider());
  }

  Future<void> _saveAvatarAndUpdateUI(File localFile, String userId) async {
    isAvatarLoading.value = true;
    try {
      final savedPath = await _saveAvatarUseCase.call(
        userId: userId,
        imageFile: localFile,
      );
      userPhotoUrl.value = savedPath;
      _snackBarService.showSuccess(
        title: 'Sucesso!',
        message: 'Avatar atualizado!',
      );
    } catch (e) {
      _snackBarService.showError(
        title: 'Erro',
        message: 'Não foi possível salvar o avatar.',
      );
    } finally {
      isAvatarLoading.value = false;
    }
  }

  Future<void> _loadCachedAvatar() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    try {
      final path = await _getCachedAvatarPathUseCase.call(userId: userId);
      if (path != null && path.isNotEmpty) {
        userPhotoUrl.value = path;
      }
    } catch (e) {
      debugPrint("Falha ao carregar avatar do cache: $e");
    }
  }

  void _updateAvatarImageProvider() {
    final url = userPhotoUrl.value;
    if (url.isNotEmpty) {
      if (url.startsWith('http')) {
        avatarImageProvider.value = NetworkImage(url);
      } else if (File(url).existsSync()) {
        avatarImageProvider.value = FileImage(File(url));
      } else {
        avatarImageProvider.value = null;
      }
    } else {
      avatarImageProvider.value = null;
    }
  }
}
