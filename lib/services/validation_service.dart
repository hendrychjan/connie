class ValidationService {
  static String? validateField(String? value, List<String>? validationRules) {
    // No validation at all
    if (validationRules == null) {
      return null;
    }

    // Required field
    if (validationRules.contains("required")) {
      if (value == null || value.isEmpty) {
        return "This field is required";
      }
    }

    return null;
  }
}
