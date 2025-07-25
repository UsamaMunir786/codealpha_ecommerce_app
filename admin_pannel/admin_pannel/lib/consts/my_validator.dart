class MyValidator {
  static String? uploadProdTexts({String? value, String? toBeReturneddString}){
      if(value!.isEmpty){
        return toBeReturneddString;
      }
      return null;
  }
}
