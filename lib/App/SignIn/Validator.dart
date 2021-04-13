abstract class validator {
  bool Isvalid(String validators);
}

class NonEmptyValidator implements validator {
  @override
  bool Isvalid(String validators) {
    return validators.isNotEmpty;
  }
}

class emailandPasswordValidator {
  final validator emailvalidator = NonEmptyValidator();
  final validator passwordvalidator = NonEmptyValidator();
  final String emailError = 'email can\t be empty';
  final String passwordError = 'password can\t be empty';
}
