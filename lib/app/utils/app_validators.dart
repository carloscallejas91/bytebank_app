import 'package:get/get.dart';

class AppValidators {
  AppValidators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'O campo de e-mail é obrigatório.';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Por favor, insira um e-mail válido.';
    }
    return null;
  }

  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo de senha é obrigatório.';
    }

    if (value.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres.';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Deve conter pelo menos uma letra minúscula.';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Deve conter pelo menos uma letra maiúscula.';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Deve conter pelo menos um número.';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Deve conter pelo menos um caractere especial.';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'O campo de senha é obrigatório.';
    }
    if (value.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres.';
    }

    return null;
  }

  static String? confirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'A confirmação de senha é obrigatória.';
    }
    if (password != confirmPassword) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  static String? notEmpty(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Este campo é obrigatório.';
    }
    return null;
  }
}