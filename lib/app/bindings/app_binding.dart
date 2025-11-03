import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/data/datasources/firebase_data_source.dart';
import 'package:mobile_app/data/datasources/firebase_storage_data_source.dart';
import 'package:mobile_app/data/repositories/firebase_auth_repository_impl.dart';
import 'package:mobile_app/data/repositories/firebase_data_repository_impl.dart';
import 'package:mobile_app/data/repositories/firebase_storage_repository_impl.dart';
import 'package:mobile_app/data/repositories/image_picker_repository_impl.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/repositories/i_image_picker_repository.dart';
import 'package:mobile_app/domain/repositories/i_storage_repository.dart';
import 'package:mobile_app/domain/repositories/i_user_repository.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';
import 'package:mobile_app/domain/usecases/add_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/calculate_dashboard_summaries_usecase.dart';
import 'package:mobile_app/domain/usecases/create_user_usecase.dart';
import 'package:mobile_app/domain/usecases/delete_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/get_cached_avatar_path_usecase.dart';
import 'package:mobile_app/domain/usecases/get_transactions_usecase.dart';
import 'package:mobile_app/domain/usecases/get_user_stream_usecase.dart';
import 'package:mobile_app/domain/usecases/pick_image_usecase.dart';
import 'package:mobile_app/domain/usecases/save_avatar_usecase.dart';
import 'package:mobile_app/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:mobile_app/domain/usecases/sign_in_usecase.dart';
import 'package:mobile_app/domain/usecases/sign_out_usecase.dart';
import 'package:mobile_app/domain/usecases/update_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/upload_receipt_usecase.dart';
import 'package:mobile_app/modules/splash/controllers/redirect_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<SnackBarService>(SnackBarService(), permanent: true);

    // Sources
    Get.put<FirebaseDataSource>(FirebaseDataSource(), permanent: true);
    Get.put<FirebaseStorageDataSource>(
      FirebaseStorageDataSource(),
      permanent: true,
    );

    // Repositories
    Get.put<IAuthRepository>(
      FirebaseAuthRepositoryImpl(Get.find()),
      permanent: true,
    );
    final dataRepository = FirebaseDataRepositoryImpl(Get.find());
    Get.put<IUserRepository>(dataRepository, permanent: true);
    Get.put<ITransactionRepository>(dataRepository, permanent: true);
    Get.put<IStorageRepository>(
      FirebaseStorageRepositoryImpl(Get.find()),
      permanent: true,
    );
    Get.put<IImagePickerRepository>(
      ImagePickerRepositoryImpl(),
      permanent: true,
    );

    // Use Cases
    Get.lazyPut(() => SignInUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CreateUserUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => SignOutUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => SendPasswordResetEmailUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetUserStreamUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetTransactionsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => AddTransactionUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateTransactionUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteTransactionUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UploadReceiptUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CalculateDashboardSummariesUseCase(), fenix: true);
    Get.lazyPut(() => SaveAvatarUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetCachedAvatarPathUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => PickImageUseCase(Get.find()), fenix: true);

    // Controllers
    Get.put<RedirectController>(RedirectController(), permanent: true);
  }
}
