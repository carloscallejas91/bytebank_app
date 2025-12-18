import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/data/datasources/firebase_data_source.dart';
import 'package:mobile_app/data/datasources/firebase_storage_data_source.dart';
import 'package:mobile_app/data/datasources/local_data_source.dart';
import 'package:mobile_app/data/repositories/firebase_auth_repository_impl.dart';
import 'package:mobile_app/data/repositories/firebase_data_repository_impl.dart';
import 'package:mobile_app/data/repositories/firebase_storage_repository_impl.dart';
import 'package:mobile_app/data/repositories/image_picker_repository_impl.dart';
import 'package:mobile_app/data/repositories/network_info_impl.dart';
import 'package:mobile_app/data/repositories/url_launcher_repository_impl.dart';
import 'package:mobile_app/data/repositories/uuid_generator_repository_impl.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/repositories/i_id_generator_repository.dart';
import 'package:mobile_app/domain/repositories/i_image_picker_repository.dart';
import 'package:mobile_app/domain/repositories/i_local_data_source.dart';
import 'package:mobile_app/domain/repositories/i_network_info.dart';
import 'package:mobile_app/domain/repositories/i_storage_repository.dart';
import 'package:mobile_app/domain/repositories/i_url_launcher_repository.dart';
import 'package:mobile_app/domain/repositories/i_user_repository.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';
import 'package:mobile_app/domain/usecases/add_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/calculate_dashboard_summaries_usecase.dart';
import 'package:mobile_app/domain/usecases/create_user_usecase.dart';
import 'package:mobile_app/domain/usecases/delete_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/generate_id_usecase.dart';
import 'package:mobile_app/domain/usecases/get_cached_avatar_path_usecase.dart';
import 'package:mobile_app/domain/usecases/get_transactions_usecase.dart';
import 'package:mobile_app/domain/usecases/get_user_stream_usecase.dart';
import 'package:mobile_app/domain/usecases/launch_url_usecase.dart';
import 'package:mobile_app/domain/usecases/map_auth_exception_to_message_usecase.dart';
import 'package:mobile_app/domain/usecases/pick_image_usecase.dart';
import 'package:mobile_app/domain/usecases/resolve_receipt_url_usecase.dart';
import 'package:mobile_app/domain/usecases/save_avatar_usecase.dart';
import 'package:mobile_app/domain/usecases/save_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:mobile_app/domain/usecases/sign_in_usecase.dart';
import 'package:mobile_app/domain/usecases/sign_out_usecase.dart';
import 'package:mobile_app/domain/usecases/toggle_sort_order_usecase.dart';
import 'package:mobile_app/domain/usecases/toggle_transaction_type_filter_usecase.dart';
import 'package:mobile_app/domain/usecases/update_transaction_usecase.dart';
import 'package:mobile_app/domain/usecases/upload_receipt_usecase.dart';
import 'package:mobile_app/modules/redirect/controllers/redirect_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<SnackBarService>(SnackBarService(), permanent: true);

    // Sources
    Get.lazyPut<ILocalDataSource>(() => LocalDataSource());
    Get.put<FirebaseDataSource>(FirebaseDataSource(), permanent: true);
    Get.put<FirebaseStorageDataSource>(
      FirebaseStorageDataSource(),
      permanent: true,
    );

    // Repositories
    Get.lazyPut<INetworkInfo>(() => NetworkInfoImpl(Connectivity()));

    // Repositories - Firebase
    Get.put<IAuthRepository>(
      FirebaseAuthRepositoryImpl(Get.find()),
      permanent: true,
    );
    final dataRepository = FirebaseDataRepositoryImpl(
      Get.find(),
      Get.find(),
      Get.find(),
    );
    Get.put<IUserRepository>(dataRepository, permanent: true);
    Get.put<ITransactionRepository>(dataRepository, permanent: true);
    Get.put<IStorageRepository>(
      FirebaseStorageRepositoryImpl(Get.find()),
      permanent: true,
    );

    // Repositories - Device & Utility
    Get.put<IImagePickerRepository>(
      ImagePickerRepositoryImpl(),
      permanent: true,
    );
    Get.put<IUrlLauncherRepository>(
      UrlLauncherRepositoryImpl(),
      permanent: true,
    );
    Get.put<IIdGeneratorRepository>(
      UuidGeneratorRepositoryImpl(),
      permanent: true,
    );

    // Use Cases - Authentication
    Get.lazyPut(() => SignInUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CreateUserUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => SignOutUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => SendPasswordResetEmailUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => MapAuthExceptionToMessageUseCase(), fenix: true);

    // Use Cases - User & Avatar
    Get.lazyPut(() => GetUserStreamUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => SaveAvatarUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetCachedAvatarPathUseCase(Get.find()), fenix: true);

    // Use Cases - Transaction
    Get.lazyPut(() => GetTransactionsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => AddTransactionUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateTransactionUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteTransactionUseCase(Get.find()), fenix: true);
    Get.lazyPut(
      () => SaveTransactionUseCase(Get.find(), Get.find()),
      fenix: true,
    );
    Get.lazyPut(() => UploadReceiptUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => ToggleTransactionTypeFilterUseCase(), fenix: true);
    Get.lazyPut(() => ToggleSortOrderUseCase(), fenix: true);
    Get.lazyPut(() => ResolveReceiptUrlUseCase(Get.find()), fenix: true);

    // Use Cases - Dashboard
    Get.lazyPut(() => CalculateDashboardSummariesUseCase(), fenix: true);

    // Use Cases - Utility
    Get.lazyPut(() => PickImageUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => LaunchUrlUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GenerateIdUseCase(Get.find()), fenix: true);

    // Global Controllers
    Get.put<RedirectController>(RedirectController(), permanent: true);
  }
}
