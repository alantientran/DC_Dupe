import 'package:get/get.dart';
import 'package:DC/pages/home_page.dart';
import 'package:DC/pages/detailer_page.dart';
import 'package:DC/pages/user_home_page.dart';

class Routes {
  static const String homePage = '/home_page';
  static const String detailerPage = '/detailer_page';
  static const String userHomePage = '/user_home_page';

  static final List<GetPage> pages = [
    GetPage(
      name: Routes.homePage,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.detailerPage,
      page: () => const DetailerPage(role: 'detailer'),
    ),
    GetPage(
      name: Routes.userHomePage,
      page: () => UserHomePage(),
    ),
  ];
}
