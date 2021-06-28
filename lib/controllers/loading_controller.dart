import 'package:get/get.dart';

class LoadingController extends GetxController {
  bool loading = false;

  setLoadingTrue() {
    loading = true;
    update();
  }

  setLoadingFalse() {
    loading = false;
    update();
  }
}
