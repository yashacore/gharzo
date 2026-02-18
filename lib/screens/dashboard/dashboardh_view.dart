import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_home_widget/common_home_widget.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/add_properties/add_property_type/add_property_view.dart';
import 'package:gharzo_project/screens/dashboard/dashboard_provider.dart';
import 'package:gharzo_project/screens/home/home_provider.dart';
import 'package:gharzo_project/screens/lanloard/lanloard_basic_details/lanloard_basic_datails_view.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DashboardProvider>().fetchProperties();
      context.read<HomeProvider>().saveToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: CommonWidget.gradientAppBar(
            title: PageConstVar.dashBoard,
            onPressed: () {
              provider.clickOnBtn(context);
            },
          ),
          body: Container(

            child: Column(
              children: [
                CommonHomeWidgets.searchBarView(),
                SizedBox(height: 16),
                Expanded(
                  child: provider.isLoading
                      ?  Center(
                    child: CircularProgressIndicator(),
                  )
                      : provider.properties.isEmpty
                      ?  Center(
                    child: Text("No properties found"),
                  )
                      : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                     SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: provider.properties.length,
                    itemBuilder: (context, index) {
                      final property = provider.properties[index];
                      final imageUrl = property.images.isNotEmpty
                          ? property.images[0]['url']
                          : null;
                      final location =
                          property.location['address'] ?? '';
                      final priceAmount =
                          property.price['amount']?.toString() ?? '-';
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Property Image
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: imageUrl != null
                                    ? Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                  const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                )
                                    : const Center(
                                    child: Icon(
                                      Icons.home_outlined,
                                      size: 50,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                   SizedBox(height: 4),
                                  Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                     TextStyle(fontSize: 12),
                                  ),
                                   SizedBox(height: 4),
                                  Text(
                                    '₹$priceAmount',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        property.status,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: property.status
                                              .toLowerCase() ==
                                              'approved'
                                              ? Colors.green
                                              : Colors.orange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SinglePropertyView(propertyId: property.id),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPropertyView(),
                ),
              );
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppThemeColors().backgroundLeft,
                    AppThemeColors().backgroundRight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Icon(Icons.add, color: Colors.white),
                   SizedBox(width: 8),
                  Text(
                    "Add Property",
                    style: TextStyle(
                      color: AppThemeColors().textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
