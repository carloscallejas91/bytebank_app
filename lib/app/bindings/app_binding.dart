import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/services/storage_service.dart';
import 'package:mobile_app/data/datasources/firebase_data_source.dart';
import 'package:mobile_app/data/repositories/firebase_auth_repository_impl.dart';
import 'package:mobile_app/data/repositories/firebase_data_repository_impl.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';
import 'package:mobile_app/domain/repositories/i_user_repository.dart';
import 'package:mobile_app/domain/usecases/add_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/create_user_usecase.dart';
import 'package:mobile_app/domain/usecases/delete_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/get_transactions_usecase.dart';
import 'package:mobile_app/domain/usecases/get_user_stream_usecase.dart';
import 'package:mobile_app/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:mobile_app/domain/usecases/sign_in_usecase.dart';
import 'package:mobile_app/domain/usecases/sign_out_usecase.dart';
import 'package:mobile_app/domain/usecases/update_transaction_usecase.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<SnackBarService>(SnackBarService(), permanent: true);
    Get.put<StorageService>(StorageService(), permanent: true);

    // DataSource
    Get.put<FirebaseDataSource>(FirebaseDataSource(), permanent: true);

    // Repositories
    Get.put<IAuthRepository>(
      FirebaseAuthRepositoryImpl(Get.find()),
      permanent: true,
    );

    final dataRepository = FirebaseDataRepositoryImpl(Get.find());
    Get.put<IUserRepository>(dataRepository, permanent: true);
    Get.put<ITransactionRepository>(dataRepository, permanent: true);

    // Auth Use Cases
    Get.lazyPut(() => SignInUseCase(Get.find()));
    Get.lazyPut(() => CreateUserUseCase(Get.find()));
    Get.lazyPut(() => SignOutUseCase(Get.find()));
    Get.lazyPut(() => SendPasswordResetEmailUseCase(Get.find()));

    // User Use Cases
    Get.lazyPut(() => GetUserStreamUseCase(Get.find()));

    // Transaction Use Cases
    Get.lazyPut(() => GetTransactionsUseCase(Get.find()));
    Get.lazyPut(() => AddTransactionUseCase(Get.find()));
    Get.lazyPut(() => UpdateTransactionUseCase(Get.find()));
    Get.lazyPut(() => DeleteTransactionUseCase(Get.find()));
  }
}