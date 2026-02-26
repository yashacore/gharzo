import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';

class FeaturesProvider extends ChangeNotifier {
  // ================= STATE =================
  bool loading = false;
  String? error;
  bool fireExtinguisher = false;
  bool fireSensor = false;
  bool sprinklers = false;
  bool fireHoseReel = false;

  // ================= MASTER LISTS (STATIC) =================
  final List<String> essentialMaster = [
    "Lift",
    "Power Backup",
    "Piped Gas",
    "Water Storage",
    "Rainwater Harvesting",
    "Waste Disposal",
    "Sewage Treatment Plant",
    "DG Backup",
    "Solar Panels",
  ];

  final List<String> nearbyMaster = [
    "School",
    "Hospital",
    "Market",
    "ATM",
    "Bank",
    "Metro Station",
    "Bus Stop",
    "Railway Station",
    "Mall",
    "Restaurant",
    "Pharmacy",
    "Park",
  ];

  // ================= SELECTED (FROM PAYLOAD) =================
  List<String> essentialSelected = [];
  List<String> nearbySelected = [];

  // ================= PROPERTY FEATURES =================
  String powerBackup = "None";
  String waterSupply = "Both";
  String flooring = "Cement";
  String constructionQuality = "Standard";
  String wasteDisposal = "Private";

  int? ceilingHeight;
  int? widthOfFacingRoad;

  bool gatedSecurity = false;
  bool liftAvailable = false;
  bool petFriendly = false;
  bool bachelorsAllowed = false;
  bool nonVegAllowed = false;
  bool boundaryWall = false;

  // ================= LOAD (EDIT MODE) =================
  Future<void> load(String propertyId) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final res = await ApiServiceMethod.getPropertyById(propertyId);
      if (res['success'] != true) {
        error = res['message'];
        return;
      }

      final d = res['data'];
      final amenities = d['amenities'] ?? {};
      final f = d['propertyFeatures'] ?? {};

      // ---------- AMENITIES ----------
      essentialSelected = List<String>.from(amenities['essential'] ?? []);
      nearbySelected = List<String>.from(amenities['nearby'] ?? []);

      // ---------- PROPERTY FEATURES ----------
      powerBackup = f['powerBackup'] ?? powerBackup;
      waterSupply = f['waterSupply'] ?? waterSupply;
      flooring = f['flooring'] ?? flooring;
      constructionQuality = f['constructionQuality'] ?? constructionQuality;
      wasteDisposal = f['wasteDisposal'] ?? wasteDisposal;

      ceilingHeight = f['ceilingHeight'];
      widthOfFacingRoad = f['widthOfFacingRoad'];

      gatedSecurity = f['gatedSecurity'] ?? false;
      liftAvailable = f['liftAvailable'] ?? false;
      petFriendly = f['petFriendly'] ?? false;
      bachelorsAllowed = f['bachelorsAllowed'] ?? false;
      nonVegAllowed = f['nonVegAllowed'] ?? false;
      boundaryWall = f['boundaryWall'] ?? false;
    } catch (e) {
      error = "Failed to load property features";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ================= CHIP TOGGLES =================
  void toggleEssential(String value) {
    essentialSelected.contains(value)
        ? essentialSelected.remove(value)
        : essentialSelected.add(value);
    notifyListeners();
  }

  void toggleNearby(String value) {
    nearbySelected.contains(value)
        ? nearbySelected.remove(value)
        : nearbySelected.add(value);
    notifyListeners();
  }

  // ================= SETTERS (SAFE) =================
  void setPowerBackup(String v) {
    powerBackup = v;
    notifyListeners();
  }

  void setWaterSupply(String v) {
    waterSupply = v;
    notifyListeners();
  }

  void setFlooring(String v) {
    flooring = v;
    notifyListeners();
  }

  void setConstructionQuality(String v) {
    constructionQuality = v;
    notifyListeners();
  }

  void setWasteDisposal(String v) {
    wasteDisposal = v;
    notifyListeners();
  }

  void setCeilingHeight(String v) {
    ceilingHeight = int.tryParse(v);
    notifyListeners();
  }

  void setRoadWidth(String v) {
    widthOfFacingRoad = int.tryParse(v);
    notifyListeners();
  }

  void setGatedSecurity(bool v) {
    gatedSecurity = v;
    notifyListeners();
  }

  void setLiftAvailable(bool v) {
    liftAvailable = v;
    notifyListeners();
  }

  void setPetFriendly(bool v) {
    petFriendly = v;
    notifyListeners();
  }

  void setBachelorsAllowed(bool v) {
    bachelorsAllowed = v;
    notifyListeners();
  }

  void setNonVegAllowed(bool v) {
    nonVegAllowed = v;
    notifyListeners();
  }

  void setBoundaryWall(bool v) {
    boundaryWall = v;
    notifyListeners();
  }

  // ================= SUBMIT =================
  Future<bool> submit(String propertyId) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final body = {
        "amenities": {"essential": essentialSelected, "nearby": nearbySelected},
        "propertyFeatures": {
          "powerBackup": powerBackup,
          "waterSupply": waterSupply,
          "flooring": flooring,
          "constructionQuality": constructionQuality,
          "wasteDisposal": wasteDisposal,
          "ceilingHeight": ceilingHeight,
          "widthOfFacingRoad": widthOfFacingRoad,
          "gatedSecurity": gatedSecurity,
          "liftAvailable": liftAvailable,
          "petFriendly": petFriendly,
          "bachelorsAllowed": bachelorsAllowed,
          "nonVegAllowed": nonVegAllowed,
          "boundaryWall": boundaryWall,
          "fireSafety": {
            "fireExtinguisher": fireExtinguisher,
            "fireSensor": fireSensor,
            "sprinklers": sprinklers,
            "fireHoseReel": fireHoseReel,
          },
        },
      };

      debugPrint("🟢 SUBMIT FEATURES START");
      debugPrint("🆔 Property ID: $propertyId");
      debugPrint("📤 Payload:");
      debugPrint(const JsonEncoder.withIndent('  ').convert(body));

      final res = await ApiServiceMethod.updateFeatures(propertyId, body);

      debugPrint("📥 Submit Response: $res");
      debugPrint("🟢 SUBMIT FEATURES END");

      return res['success'] == true;
    } catch (e, s) {
      debugPrint("❌ SUBMIT FEATURES ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      error = "Failed to save property features";
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
