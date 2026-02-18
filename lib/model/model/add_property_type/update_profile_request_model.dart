class UpdateProfileRequestModel {
  String? name;
  String? phone;
  Address? address;

  UpdateProfileRequestModel({this.name, this.phone, this.address});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address!.toJson();
    return data;
  }
}

class Address {
  String? city;
  String? state;
  String? pincode;

  Address({this.city, this.state, this.pincode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (pincode != null) data['pincode'] = pincode;
    return data;
  }
}
