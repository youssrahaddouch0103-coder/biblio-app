class Validators {
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est obligatoire';
    }
    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final year = int.tryParse(value);

    if (year == null) {
      return 'Année invalide';
    }

    final currentYear = DateTime.now().year;

    if (year < 1000 || year > currentYear) {
      return 'Année entre 1000 et $currentYear';
    }

    return null;
  }
}