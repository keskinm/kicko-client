import 'package:email_validator/email_validator.dart';

class Validator {

  bool validatePassword({required String? value}) {
    if (value == null || value.length < 8) {
      return false;
    } else {
      return true;
    }
  }

  bool validateUsername({required String? value}) {
    if (value == null || value.length < 4) {
      return false;
    } else {
      return true;
    }
  }

  bool validateEmail({required String? value}) {
    if (value != null) {
      if (EmailValidator.validate(value)) {
        return true;
      }
    }
    return false;
  }
}
