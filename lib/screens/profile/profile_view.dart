import 'package:flutter/material.dart';
import 'package:gharzo_project/channel_partner_screen.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar_provider.dart';
import 'package:gharzo_project/screens/contact_us_screen.dart';
import 'package:gharzo_project/screens/dashboard/dashboard_provider.dart';
import 'package:gharzo_project/screens/dashboard/dashboardh_view.dart';
import 'package:gharzo_project/screens/edit_profile/edit_profile_view.dart';
import 'package:gharzo_project/screens/franchise_req_form.dart';
import 'package:gharzo_project/screens/mortgage_form.dart';
import 'package:gharzo_project/screens/profile/profile_provider.dart';
import 'package:gharzo_project/screens/wishlist_screen.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
            
                /// 🔹 Background Gradient Header
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppThemeColors().backgroundLeft,
                        AppThemeColors().backgroundRight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
            
                /// 🔹 Content
                SafeArea(
                  child: Column(
                    children: [
            
                      /// 🔹 App Bar Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SizedBox(
                          height: 48,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [

                              /// 🔹 Center Title (always centered)
                              const Center(
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              /// 🔹 Right Action (dashboard)
                              if (value.isLandlord)
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.dashboard,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      navigatorKey.currentState?.pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => ChangeNotifierProvider(
                                            create: (_) => DashboardProvider(),
                                            child: DashboardView(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
            
                      const SizedBox(height: 20),
            
                      /// 🔹 Profile Avatar
                      CircleAvatar(
                        radius: 47,
                        backgroundImage: value.profileImage.isNotEmpty &&
                            value.profileImage.startsWith('http')
                            ? NetworkImage(value.profileImage)
                            : null,
                        child: value.profileImage.isEmpty
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
            
                      const SizedBox(height: 12),
            
                      /// 🔹 Name + Edit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value.userName.isNotEmpty
                                ? value.userName
                                : "User",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => navigatorKey.currentState?.push(
                              MaterialPageRoute(
                                  builder: (_) => EditProfileView()),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.edit_outlined,
                                      size: 14, color: Color(0xFF2563EB)),
                                  SizedBox(width: 4),
                                  Text(
                                    "Edit",
                                    style: TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
            
                      const SizedBox(height: 30),
            
                      /// 🔹 Scrollable Body
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            buildSectionCard([
                              listTileView(Icons.favorite_outline,
                                  "Saved properties", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SavedPropertiesScreen(
                                        ),
                                      ),
                                    );

                                  }
                              ),
                              listTileView(
                                  Icons.history, "Recent searches",null),
                              listTileView(Icons.visibility_outlined,
                                  "Seen properties",null),
                              listTileView(Icons.phone_outlined,
                                  "Contacted properties",null),
                             listTileView(Icons.handshake_outlined,
                                  "Channel Partner",
                                 (){
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (_) => ChannelPartnerScreen(
                                       ),
                                     ),
                                   );

                                 }
                             ),
                              listTileView(Icons.place_outlined,
                                  "Franchise Request",
                                 (){
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (_) => FranchiseEnquiryView(
                                       ),
                                     ),
                                   );

                                 }
                             ),

                              listTileView(Icons.landscape_sharp,
                                  "Mortgage Request",
                                 (){
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (_) => MortgageEnquiryView(
                                       ),
                                     ),
                                   );

                                 }
                             ),
                            ]),

                            const SizedBox(height: 25),
                            const Text("My Ads",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 10),

                            buildSectionCard([
                              listTileView(Icons.security_outlined,
                                  "My posted properties",null),
                              listTileView(Icons.laptop_chromebook,
                                  "Current plan",null),
                              listTileView(
                                  Icons.upgrade, "Upgrade plan",null),
                              listTileView(Icons.receipt_long_outlined,
                                  "Billing history",null),
                            ]),

                            const SizedBox(height: 25),
                            const Text("Help & About",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            const SizedBox(height: 10),

                            buildSectionCard([
                              listTileView(
                                  Icons.call, "Contact Us",             (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ContactUsScreen(
                                    ),
                                  ),
                                );

                              }),
                              listTileView(
                                  Icons.info_outline, "About gharzo",null),
                              listTileView(Icons.privacy_tip_outlined,
                                  "Privacy & policy",null),
                            ]),

                            const SizedBox(height: 40),
                            PrimaryButton(title: "Logout",
                              onPressed: () => value.clickOnLogoutBtn(),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Section card container
  Widget buildSectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Individual list tile
  Widget listTileView(IconData icon, String title,VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppThemeColors().primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF2563EB),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

}
