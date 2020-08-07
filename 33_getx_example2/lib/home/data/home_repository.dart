import 'package:getx_example2/home/data/home_provider.dart';
import 'package:getx_example2/home/data/home_model.dart';

class HomeRepository {
  HomeRepository(this.homeProvider);
  final HomeProvider homeProvider;

  Future<ApiModel> getData() async {
    return homeProvider.fetchData();
  }
}
