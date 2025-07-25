class MyValidator {
  static String? displayNameValidator(String? displayName){
    if(displayName == null || displayName.isEmpty){
      return 'Display name cannot be empty';
    }
    if(displayName.length < 3 || displayName.length > 20){
      return 'Display name between 3 and 20 letters';
    }
    return null;
  }

  static String? emailValidator(String? value){
    if(value == null || value.isEmpty){
      return 'Please enter a email';
    }
    if(!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value){
    if(value!.isEmpty){
      return 'Please enter a password';
    }
    if(value.length < 6){
      return 'password length must be at_least 6 character';
    }
    return null;
  }
  
}
