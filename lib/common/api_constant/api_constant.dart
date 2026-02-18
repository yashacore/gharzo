class ApiConstant{

  static const String baseUrl = "https://api.gharzoreality.com/api/v2";

  static const String authUrl = "$baseUrl/auth/";

  //-------------------------------------------------- Auth

  static const String sendOtp = "https://api.gharzoreality.com/api/auth/send-otp";
  static const String verifyOTP = "https://api.gharzoreality.com/api/auth/verify-otp";
  static const String registerUrl = "https://api.gharzoreality.com/api/auth/verify-otp";
  static const String resendOTP = "https://api.gharzoreality.com/api/auth/resend-otp";



  //-------------------Home
  static const String featuredProperties = "https://api.gharzoreality.com/api/public/properties/featured";

  static const String trendingProperties = "https://api.gharzoreality.com/api/public/properties/trending";

  static const String recentProperties = "https://api.gharzoreality.com/api/public/properties/recent";

  // ---------------- CATEGORY → QUERY MAP
  static const Map<String, String> categoryToQuery = {
    'Rent': 'listingType=Rent',
    'Buy': 'listingType=Sale',
    'Commercial': 'category=Commercial',
    'PG': 'listingType=PG',
    'Hostels': 'propertyType=Hostel',
    'Banquets': 'propertyType=Banquet',
  };

  static String propertyDetails(String id) {
    return "https://api.gharzoreality.com/api/public/properties/$id";
  }

  //profile
  static const String profile = "https://api.gharzoreality.com/api/auth/me";

  //---------------------Profile Update
  static const String updateProfile = "https://api.gharzoreality.com/api/auth/update_profile";

//-------------------------------------ADD PROPERTY

  static const String createDraft =
      "https://api.gharzoreality.com/api/v2/properties/create-draft";

}
