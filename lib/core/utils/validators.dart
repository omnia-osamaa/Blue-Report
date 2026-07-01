
class Validators {
  Validators._();


  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }


  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }


  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }


  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }


  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }


  static String? egyptianNationalId(String? value) {
    if (value == null || value.isEmpty) {
      return 'National ID is required';
    }

    final cleaned = value.trim();


    if (!RegExp(r'^\d{14}$').hasMatch(cleaned)) {
      return 'National ID must be exactly 14 digits';
    }


    if (!(cleaned.startsWith('2') || cleaned.startsWith('3'))) {
      return 'Invalid National ID format';
    }


    final century = cleaned[0] == '2' ? 1900 : 2000;
    final year = int.parse(cleaned.substring(1, 3)) + century;
    final month = int.parse(cleaned.substring(3, 5));
    final day = int.parse(cleaned.substring(5, 7));

    DateTime birthDate;

    try {
      birthDate = DateTime(year, month, day);

      if (birthDate.month != month || birthDate.day != day) {
        return 'Invalid birth date in National ID';
      }
    } catch (e) {
      return 'Invalid birth date in National ID';
    }


    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    if (age < 18) {
      return 'You must be at least 18 years old';
    }

    return null;
  }


  static String? minLength(String? value, int length,
      {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < length) {
      return '${fieldName ?? 'This field'} must be at least $length characters';
    }

    return null;
  }


  static String? maxLength(String? value, int length,
      {String? fieldName}) {
    if (value == null || value.isEmpty) return null;

    if (value.length > length) {
      return '${fieldName ?? 'This field'} must not exceed $length characters';
    }

    return null;
  }


  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a number';
    }

    return null;
  }


  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}

