import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/model/lanloard/single_property_model.dart';
import 'package:gharzo_project/screens/lanloard/screens/lanloard_property_details.dart';
import 'package:gharzo_project/screens/lanloard/screens/lanloard_property_room_list.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/screens/lanloard/lanloard_basic_details/lanloard_basic_details_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

import '../../room/add_room/add_room_view.dart';

class SinglePropertyView extends StatefulWidget {
  final String propertyId;

  const SinglePropertyView({super.key, required this.propertyId});

  @override
  State<SinglePropertyView> createState() => _SinglePropertyViewState();
}

class _SinglePropertyViewState extends State<SinglePropertyView> {
  late SinglePropertyProvider provider;

  @override
  void initState() {
    super.initState();
    provider = SinglePropertyProvider();
    provider.getPropertyDetail(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SinglePropertyProvider>.value(
      value: provider,
      child: Consumer<SinglePropertyProvider>(
        builder: (context, provider, child) {
          final property = provider.propertyDetail;

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar:
            CommonWidget.gradientAppBar(title: PageConstVar.propertyDetails),
            body: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : property == null
                ? const Center(child: Text("No property details found"))
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= TABS =================
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: provider.categories.length,
                          itemBuilder: (context, index) {
                            final isSelected =
                                provider.selectedTabIndex == index;

                            return GestureDetector(
                              onTap: () {
                                provider.setTab(index);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppThemeColors().backgroundLeft
                                      : Colors.grey.shade200,
                                  borderRadius:
                                  BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  provider.categories[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // ================= TAB CONTENT =================
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildTabSection(provider, property),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
            floatingActionButton: provider.selectedTabIndex == 1
                ? commonFBtnView(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddRoomView())),
              btnText: 'Add Room'
            ) : SizedBox(),
          );
        },
      ),
    );
  }



  // ================= TAB SWITCHER =================
  Widget _buildTabSection(
      SinglePropertyProvider provider,
      SinglePropertyModel property,
      ) {
    switch (provider.selectedTabIndex) {
      case 0:
        return LanloardPropertyDetails(
          property: property,
          provider: provider,
        );

      case 1:
        return LanloardPropertyRoomList(
          propertyId: property.propertyId,
        );

      case 2:
        return _tenantDuesSection();

      case 3:
        return _commercialSection();

      case 4:
        return _banquetsSection();

      default:
        return LanloardPropertyDetails(
          property: property,
          provider: provider,
        );
    }
  }

  Widget _tenantDuesSection() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("Tenant Dues Page Yaha Aayega"),
    );
  }

  Widget _commercialSection() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("Commercial Page Yaha Aayega"),
    );
  }

  Widget _banquetsSection() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text("Banquets Page Yaha Aayega"),
    );
  }

  Widget commonFBtnView({
    required String btnText,
    GestureTapCallback? onTap,

}){
    return GestureDetector(
      onTap:onTap,
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
              btnText,
              style: TextStyle(
                color: AppThemeColors().textWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
