import 'package:get/get.dart';

class StatsController extends GetxController {
  int index = 0;
  setPageIndex(int i) {
    index = i;
    update();
  }
}
