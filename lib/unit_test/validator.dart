class Validator {
  bool isEmailValidate(String email) {
    return RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$").hasMatch(email);
  }
}
