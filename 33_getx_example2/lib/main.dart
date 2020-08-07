import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_example2/home/bindings/home_binding.dart';
import 'package:getx_example2/home/views/country_view.dart';
import 'home/views/details_view.dart';
import 'home/views/home_view.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage(), binding: HomeBinding()),
        GetPage(name: '/country', page: () => CountryPage()),
        GetPage(name: '/details', page: () => DetailsPage()),
      ],
    ),
  );
}
