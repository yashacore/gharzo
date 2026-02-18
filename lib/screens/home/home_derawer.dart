import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import '../../main.dart';
import '../login/login_view.dart';

class HomeDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const HomeDrawer({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    double drawerWidth = MediaQuery.of(context).size.width * 0.80;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: drawerWidth,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff1A5BAA), Color(0xff0A4B86)],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        "assets/logo/splash.jpeg",
                        height: 40,
                        width: 40,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Login / signup to continue",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ✅ CLOSE WITH ANIMATION
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: onClose,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 ACTION CARDS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    _drawerCard(
                      icon: Icons.person_rounded,
                      title: "Cx Profile",
                      subtitle: "Login / Signup, manage your account",
                      onTap: () {},
                    ),
                    _drawerCard(
                      icon: Icons.home_work_rounded,
                      title: "Post your property",
                      subtitle: "Rent, Sell, or Lease your property",
                      onTap: () {},
                    ),
                    _drawerCard(
                      icon: Icons.calendar_month_rounded,
                      title: "Plans & Subscriptions",
                      subtitle:
                      "Tenant / kirayedar, Owner / Landlord...",
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const Divider(indent: 20, endIndent: 20, height: 40),

              _drawerTile(
                  icon: Icons.info_outline, title: "Customer Support"),
              _drawerTile(
                  icon: Icons.face_retouching_natural_outlined,
                  title: "About Us"),
              _drawerTile(
                  icon: Icons.shield_outlined, title: "Privacy Policy"),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _drawerCard(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  subtitle: "",
                  isLogout: true,
                  onTap: () async {
                    await PrefService.clearAuthData();
                    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => LoginView()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLogout ? const Color(0xffEEF4FF) : const Color(0xffE2EAFB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xff3B7CFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title:
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle.isEmpty
            ? null
            : Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing:
        const Icon(Icons.chevron_right, color: Color(0xff3B7CFF)),
      ),
    );
  }

  Widget _drawerTile({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff3B7CFF)),
      title:
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing:
      const Icon(Icons.chevron_right, color: Color(0xff3B7CFF)),
      onTap: () {},
    );
  }
}
