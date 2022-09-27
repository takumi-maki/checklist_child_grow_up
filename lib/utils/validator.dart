class Validator {
  static final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
  );
  static String? getRequiredValidatorMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'この項目の入力は必須です';
    }
    return null;
  }

  static String? getEmailRegValidatorMessage(String? value) {
    bool result = value!.contains(Validator.emailRegExp);
    return result ? null : '有効なメールアドレスを入力して下さい';
  }

  static String? getPasswordValidatorMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードの入力は必須です';
    } else if(value.length < 6) {
      return 'パスワードは6文字以上で入力してください';
    } else {
      return null;
    }
  }
}