import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DatabaseService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Cria um documento para um novo usuário na coleção 'users'.
  /// Usa o UID da autenticação como ID do documento.
  Future<void> createUserDocument({
    required User user,
    required String name,
  }) async {
    try {
      // Cria uma referência para o documento do usuário
      final userDocRef = _firestore.collection('users').doc(user.uid);

      // Define os dados do usuário
      final userData = {
        'uid': user.uid,
        'name': name,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(), // Usa o timestamp do servidor
      };

      // Envia os dados para o Firestore
      await userDocRef.set(userData);

    } catch (e) {
      print("Erro ao criar documento do usuário: $e");
      // Relança a exceção para que o AuthService possa tratá-la se necessário
      rethrow;
    }
  }
}