import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/room/search_room_model/search_room_model.dart';


class RoomsSearchProvider extends ChangeNotifier {
  final RoomApiService _apiService = RoomApiService();

  bool isLoading = false;
  String? error;

  List<SearchRoomModel> rooms = [];

  int page = 1;
  int totalPages = 1;

  Future<void> fetchRooms({
    required String city,
    required String roomType,
    bool loadMore = false,
  }) async {
    try {
      if (!loadMore) {
        page = 1;
        rooms.clear();
        isLoading = true;
        notifyListeners();
      } else {
        if (page >= totalPages) return;
        page++;
      }

      final response = await _apiService.searchRooms(
        city: city,
        roomType: roomType,
        page: page,
      );

      totalPages = response.pages;
      rooms.addAll(response.data);

      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    rooms.clear();
    page = 1;
    totalPages = 1;
    notifyListeners();
  }
}



//-----------------Filter gender and furnishing


// class RoomsSearchProvider extends ChangeNotifier {
//   final RoomsApiService _apiService = RoomsApiService();
//
//   List<RoomModel> rooms = [];
//   bool isLoading = false;
//   String? error;
//
//   int page = 1;
//   int totalPages = 1;
//
//   String? genderPreference;
//   String? furnished;
//
//   void setFilters({
//     String? gender,
//     String? furnishingType,
//   }) {
//     genderPreference = gender;
//     furnished = furnishingType;
//     notifyListeners();
//   }
//
//   Future<void> fetchRooms({bool loadMore = false}) async {
//     try {
//       if (!loadMore) {
//         page = 1;
//         rooms.clear();
//         isLoading = true;
//         notifyListeners();
//       } else {
//         if (page >= totalPages) return;
//         page++;
//       }
//
//       final response = await _apiService.searchRooms(
//         genderPreference: genderPreference,
//         furnished: furnished,
//         page: page,
//       );
//
//       totalPages = response.pages;
//       rooms.addAll(response.data);
//
//       error = null;
//     } catch (e) {
//       error = e.toString();
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void clearFilters() {
//     genderPreference = null;
//     furnished = null;
//     fetchRooms();
//   }
// }



//---------------combined filter
// class RoomsSearchProvider extends ChangeNotifier {
//   final RoomsApiService _apiService =
//   RoomsApiService();
//
//   List<RoomModel> rooms = [];
//
//   bool isLoading = false;
//   String? error;
//
//   int page = 1;
//   int totalPages = 1;
//
//   // 🔥 FILTERS
//   String? city;
//   String? locality;
//   String? roomType;
//   int? minRent;
//   int? maxRent;
//   String? genderPreference;
//
//   // ✅ Set All Filters Together
//   void setFilters({
//     String? cityValue,
//     String? localityValue,
//     String? roomTypeValue,
//     int? minRentValue,
//     int? maxRentValue,
//     String? genderValue,
//   }) {
//     city = cityValue;
//     locality = localityValue;
//     roomType = roomTypeValue;
//     minRent = minRentValue;
//     maxRent = maxRentValue;
//     genderPreference = genderValue;
//
//     notifyListeners();
//   }
//
//   // ✅ Fetch Rooms
//   Future<void> fetchRooms({bool loadMore = false}) async {
//     try {
//       if (!loadMore) {
//         page = 1;
//         rooms.clear();
//         isLoading = true;
//         notifyListeners();
//       } else {
//         if (page >= totalPages) return;
//         page++;
//       }
//
//       final response =
//       await _apiService.searchRooms(
//         city: city,
//         locality: locality,
//         roomType: roomType,
//         minRent: minRent,
//         maxRent: maxRent,
//         genderPreference: genderPreference,
//         page: page,
//       );
//
//       totalPages = response.pages;
//       rooms.addAll(response.data);
//
//       error = null;
//     } catch (e) {
//       error = e.toString();
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // ✅ Clear All Filters
//   void clearFilters() {
//     city = null;
//     locality = null;
//     roomType = null;
//     minRent = null;
//     maxRent = null;
//     genderPreference = null;
//
//     fetchRooms();
//   }
// }