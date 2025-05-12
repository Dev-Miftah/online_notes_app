import 'package:get/get.dart';
import '../presentation/controllers/auth_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register all controllers here
    Get.lazyPut<AuthController>(() => AuthController());
   // Get.lazyPut<NoteController>(() => NoteController());
  }
}
