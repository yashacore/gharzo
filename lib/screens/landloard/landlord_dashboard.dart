import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/landloard/annoucment/announcement_list_screen.dart';
import 'package:gharzo_project/screens/landloard/complaints/complalint_list_screen.dart';
import 'package:gharzo_project/screens/landloard/create_tenant/tenant_dashboard.dart';
import 'package:gharzo_project/screens/landloard/sub_owner/create_sub_owner_screen.dart';
import 'package:gharzo_project/screens/landloard/create_tenant/create_tenancy_screen.dart';
import 'package:gharzo_project/screens/landloard/landlord_properties/landlord_my_properties.dart';
import 'package:gharzo_project/screens/landloard/sub_owner/sub_owner_dashboard.dart';
import 'package:gharzo_project/screens/landloard/workers/worker_list_screen.dart';
import 'package:gharzo_project/screens/payments/payment_dashboard.dart';

class LandlordDashboard extends StatelessWidget {
  const LandlordDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern off-white background
      appBar: CommonWidget.gradientAppBar(
        title: "Landlord Hub",
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            const Text(
              "Welcome back, Landlord",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Manage your real estate empire",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 30),

            // Main Stats / Quick Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.3,
              children: [
                _buildMenuCard(
                  context,
                  title: 'My Properties',
                  subtitle: '12 Units',
                  icon: Icons.apartment_rounded,
                  color: Colors.blue,
                  onTap: () {
                    /* Navigate to Properties */
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPropertiesScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'Tenant',
                  subtitle: 'New lease',
                  icon: Icons.person_add_alt_1_rounded,
                  color: Colors.orange,
                  onTap: () {
                    /* Navigate to Add Tenant */
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TenantDashboardScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'Announcement',
                  subtitle: '1',
                  icon: Icons.bed_rounded,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnnouncementListScreen(),
                      ),
                    );
                    /* Navigate to Add Room */
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'Sub-Owner',
                  subtitle: 'Manage staff',
                  icon: Icons.group_add_rounded,
                  color: Colors.purple,
                  onTap: () {
                    /* Navigate to Add Sub-owner */
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubOwnerDashboardScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'Complaints',
                  subtitle: 'Manage Complaints',
                  icon: Icons.group_add_rounded,
                  color: Colors.purple,
                  onTap: () {
                    /* Navigate to Add Sub-owner */
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LandlordComplaintsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  title: 'Workers',
                  subtitle: 'Manage Workers',
                  icon: Icons.group_add_rounded,
                  color: Colors.purple,
                  onTap: () {
                    /* Navigate to Add Sub-owner */
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkerListScreen(),
                      ),
                    );
                  },
                ),


                _buildMenuCard(
                  context,
                  title: 'Payments',
                  subtitle: 'Manage Payments',
                  icon: Icons.credit_card,
                  color: Colors.purple,
                  onTap: () {
                    /* Navigate to Add Sub-owner */
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentDashboardScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Recent Activity Section
            const Text(
              "Recent Activity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildActivityTile(
              "Rent collected - Unit 4B",
              "2 hours ago",
              Icons.check_circle,
              Colors.green,
            ),
            _buildActivityTile(
              "New Tenant Inquiry",
              "5 hours ago",
              Icons.mail,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  // Stylish Menu Card Builder
  Widget _buildMenuCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT
              mainAxisAlignment: MainAxisAlignment.center, // ✅ FIX
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTile(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            time,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
