import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/screens/add_properties/add_property_type/add_property_view.dart';
import 'package:gharzo_project/screens/home/home_view.dart';
import 'package:gharzo_project/screens/login/login_view.dart';
import 'package:gharzo_project/screens/plan/plan_view.dart';
import 'package:gharzo_project/screens/profile/profile_view.dart';
import 'package:gharzo_project/screens/reels/reels_feed/reels_feed_view.dart';


class BottomBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  Future<bool> isLoggedIn() async {
    final token = await PrefService.getToken();
    return token != null && token.isNotEmpty;
  }

  void setIndex(int index, BuildContext context) async {
    final loggedIn = await isLoggedIn();

    if (!loggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
      );
      return;
    }

    _currentIndex = index;
    notifyListeners();
  }

  Widget currentPage(VoidCallback openDrawer) {
    switch (_currentIndex) {
      case 0:
        return HomeView(action: openDrawer);
      case 1:
        return PlanView();
      case 2:
        return AddPropertyView();
      case 3:
        return ReelsFeedView();
      case 4:
        return ProfilePage();
      default:
        return HomeView(action: openDrawer);
    }
  }
  bool isBottomBarVisible = true;
  void setBottomBarVisibility(bool visible) {
    if (isBottomBarVisible != visible) {
      isBottomBarVisible = visible;
      notifyListeners();
    }
  }
}
