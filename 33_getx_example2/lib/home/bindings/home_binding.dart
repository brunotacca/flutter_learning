import 'package:get/get.dart';
import 'package:getx_example2/home/controllers/home_controller.dart';
import 'package:getx_example2/home/data/home_provider.dart';
import 'package:getx_example2/home/data/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() {
      final homeProvider = HomeProvider();
      final homeRepository = HomeRepository(homeProvider);
      return HomeController(homeRepository);
    });
  }
}
