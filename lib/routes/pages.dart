import 'package:gharzo_project/providers/banquet_provider.dart';
import 'package:gharzo_project/providers/contac_us_provider.dart';
import 'package:gharzo_project/providers/home_loan_enquiry_provider.dart';
import 'package:gharzo_project/providers/hotel_provider.dart';
import 'package:gharzo_project/providers/search_provider.dart';
import 'package:gharzo_project/providers/services_provider.dart';
import 'package:gharzo_project/screens/add_properties/upload_photo/upload_photo_provider.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar_provider.dart';
import 'package:gharzo_project/screens/category/category_provider.dart';
import 'package:gharzo_project/screens/dashboard/dashboard_provider.dart';
import 'package:gharzo_project/screens/edit_profile/edit_profile_provider.dart';
import 'package:gharzo_project/screens/home/home_provider.dart';
import 'package:gharzo_project/screens/lanloard/lonloard_create_tanant/lanloard_provider.dart';
import 'package:gharzo_project/screens/lanloard/screens/lanloard_rooms_view/lanloard_all_room_provider.dart';
import 'package:gharzo_project/screens/login/login_provider.dart';
import 'package:gharzo_project/screens/onboardring/onboarding_provider.dart';
import 'package:gharzo_project/screens/plan/plan_provider.dart';
import 'package:gharzo_project/screens/profile/profile_provider.dart';
import 'package:gharzo_project/screens/property_details/property_details_provider.dart';
import 'package:gharzo_project/screens/reels/reels_feed/reels_feed_provider.dart';
import 'package:gharzo_project/screens/splash/splash_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../screens/add_properties/add_property_type/add_property_provider.dart';
import '../screens/notification/notification_provider.dart';
import '../screens/room/add_room/add_room_provider.dart';

List<SingleChildWidget> appProviders = [

  ChangeNotifierProvider(create: (_) => SplashProvider()),
  ChangeNotifierProvider(create: (_) => OnboardingProvider()),
  ChangeNotifierProvider(create: (_) => LoginProvider()),
  ChangeNotifierProvider(create: (_) => BottomBarProvider()),
  ChangeNotifierProvider(create: (_) => HomeProvider()),
  ChangeNotifierProvider(create: (_) => CategoryProvider('Rent')),
  ChangeNotifierProvider(create: (_) => PropertyDetailProvider()),
  ChangeNotifierProvider(create: (_) => PropertyDraftProvider()),
  ChangeNotifierProvider(create: (_) => PhotoUploadProvider()),
  ChangeNotifierProvider(create: (_) => ProfileProvider()),
  ChangeNotifierProvider(create: (_) => EditProfileProvider()),
  ChangeNotifierProvider(create: (_) => ReelsFeedProvider()),
  ChangeNotifierProvider(create: (_) => PlanProvider()),
  ChangeNotifierProvider(create: (_) => DashboardProvider()),
  ChangeNotifierProvider(create: (_) => CreateTenancyProvider()),
  ChangeNotifierProvider(create: (_) => AddRoomProvider()),
  ChangeNotifierProvider(create: (_) => NotificationProvider()),
  ChangeNotifierProvider(create: (_) => AllRoomsProvider()),
  ChangeNotifierProvider(create: (_) => PropertySearchProvider()),
  ChangeNotifierProvider(create: (_) => ServicesProvider()),
  ChangeNotifierProvider(create: (_) => HomeLoanEnquiryProvider()),
  ChangeNotifierProvider(create: (_) => HotelProvider()),
  ChangeNotifierProvider(create: (_) => ContactInquiryProvider()),
  ChangeNotifierProvider(create: (_) => BanquetProvider()),



];