// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// /// 🔹 APP ROOT
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Property Listing',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         scaffoldBackgroundColor: const Color(0xffF5F6FA),
//       ),
//       home: const PropertyListScreen(),
//     );
//   }
// }
//
// // class PropertyCard extends StatelessWidget {
// //   final String price;
// //   final String title;
// //   final String location;
// //   final String imageUrl;
// //   final String postedText;
// //   final bool isImageAvailable;
//
//   const PropertyCard({
//     super.key,
//     required this.price,
//     required this.title,
//     required this.location,
//     required this.postedText,
//     this.imageUrl = '',
//     this.isImageAvailable = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔹 IMAGE
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Stack(
//                     children: [
//                       Container(
//                         height: 90,
//                         width: 90,
//                         color: Colors.grey.shade200,
//                         child: isImageAvailable
//                             ? Image.network(
//                           imageUrl,
//                           fit: BoxFit.cover,
//                         )
//                             : const Icon(Icons.apartment,
//                             size: 40, color: Colors.grey),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 3, horizontal: 6),
//                           color: Colors.black54,
//                           child: Text(
//                             postedText,
//                             style: const TextStyle(
//                                 color: Colors.white, fontSize: 10),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(width: 10),
//
//                 // 🔹 DETAILS
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             price,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Spacer(),
//                           const Icon(Icons.favorite_border, size: 20),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         location,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const Divider(height: 1),
//
//           // 🔹 BUTTONS
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {},
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFF2563EB)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                     ),
//                     child: const Text(
//                       "Get Phone No.",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF2563EB),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                     ),
//                     child: const Text(
//                       "Contact Owner",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class PropertyListScreen extends StatelessWidget {
//   const PropertyListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F6FA),
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         title: const Text("Properties"),
//         backgroundColor: Color(0xFF2563EB),
//       ),
//       body: ListView(
//         children: const [
//           PropertyCard(
//             price: "₹ 19.3 Lac",
//             title: "1 BHK Flat - 550 sqft",
//             location: "Pagnis Paga, Indore",
//             postedText: "Updated 5 days ago",
//             imageUrl: "https://picsum.photos/200",
//           ),
//           PropertyCard(
//             price: "₹ 22.8 Lac",
//             title: "1 BHK Flat - 650 sqft",
//             location: "Goyal Vihar, Indore",
//             postedText: "Posted Feb 13",
//             imageUrl: "https://picsum.photos/201",
//           ),  PropertyCard(
//             price: "₹ 22.8 Lac",
//             title: "1 BHK Flat - 650 sqft",
//             location: "Goyal Vihar, Indore",
//             postedText: "Posted Feb 13",
//             imageUrl: "https://picsum.photos/201",
//           ),
//           PropertyCard(
//             price: "₹ 12 Lac",
//             title: "1 BHK Builder Floor - 480 sqft",
//             location: "Goyal Vihar, Indore",
//             postedText: "Posted Feb 13",
//             isImageAvailable: false,
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BottomNavDemo(),
    );
  }
}

class BottomNavDemo extends StatefulWidget {
  const BottomNavDemo({super.key});

  @override
  State<BottomNavDemo> createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<BottomNavDemo> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: const Center(child: Text("Content Area")),

      // 🔥 CUSTOM BOTTOM BAR
      bottomNavigationBar: SizedBox(
        height: 85,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 🟢 BAR BACKGROUND
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navItem(
                    icon: Icons.card_giftcard,
                    label: "Top\nMatches",
                    index: 0,
                  ),
                  navItem(
                    icon: Icons.add_circle_outline,
                    label: "Post\nFree Ad",
                    index: 1,
                  ),
                  const SizedBox(width: 60), // space for center button
                  navItem(
                    icon: Icons.home_work_outlined,
                    label: "Property\nValuation",
                    index: 3,
                  ),
                  navItem(
                    icon: Icons.person_outline,
                    label: "You",
                    index: 4,
                  ),
                ],
              ),
            ),

            // 🔴 CENTER FLOATING BUTTON
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                child: Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.45),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 NAV ITEM
  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? Colors.red : Colors.black54,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.red : Colors.black54,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
