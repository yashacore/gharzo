class Validation {
  static String? mobileValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter mobile number";
    }

    final RegExp regex = RegExp(r'^[6-9]\d{9}$');

    if (!regex.hasMatch(value)) {
      return "Enter valid 10 digit mobile number";
    }

    return null; // ✅ valid
  }

  static String? otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter OTP';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    return null; // valid
  }

  static String? otpValidate({
    required String otp,
    int length = 4,
  }) {
    if (otp.isEmpty) {
      return "OTP is required";
    }

    if (otp.length != length) {
      return "Please enter a $length-digit OTP";
    }

    return null; // valid
  }

  static String? roleValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Role is required";
    }
    return null;
  }

  static String? fullNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full Name is required";
    } else if (value.trim().length < 2) {
      return "Full Name must be at least 2 characters";
    } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
      return "Full Name can only contain letters";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    } else if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value.trim())) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? requiredField(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return "${fieldName ?? 'This field'} is required";
    }
    return null;
  }

  static String? numberField(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return "${fieldName ?? 'This field'} is required";
    }
    if (double.tryParse(value) == null) {
      return "${fieldName ?? 'This field'} must be a valid number";
    }
    return null;
  }
}

