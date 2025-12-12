import 'package:firebase_auth/firebase_auth.dart';

class MapAuthExceptionToMessageUseCase {
  String call(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Nenhum usuário encontrado com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta. Verifique e tente novamente.';
      case 'invalid-email':
        return 'O formato do e-mail é inválido.';
      case 'user-disabled':
        return 'Este usuário foi desativado.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'email-already-in-use':
        return 'O e-mail já está em uso por outra conta.';
      case 'operation-not-allowed':
        return 'Operação não permitida. Contate o suporte.';
      case 'weak-password':
        return 'A senha fornecida é muito fraca.';
      default:
        return 'Ocorreu um erro desconhecido. Tente novamente!';
    }
  }
}
