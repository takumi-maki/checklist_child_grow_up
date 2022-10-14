import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getRequiredValidatorMessage', () {
    test('正常値の文字列の場合、nullが返ってくること', (){
      final actual = Validator.getRequiredValidatorMessage('test');
      expect(actual, null);
    });
    test('異常系 空文字の場合、「この項目の入力は必須です」の文字列が返ってくること', () {
      final actual = Validator.getRequiredValidatorMessage('');
      expect(actual, 'この項目の入力は必須です');
    });
    test('異常系 nullの場合、「この項目の入力は必須です」の文字列が返ってくること', (){
      final actual = Validator.getRequiredValidatorMessage(null);
      expect(actual, 'この項目の入力は必須です');
    });
  });

  group('getEmailRegValidatorMessage', () {
    const successTestCase1 = 'test@test.co.jp';
    const successTestCase2 = 'test@test.jp';
    const errorTestCase1 = 'test@test.';
    const errorTestCase2 = 'test';
    test('正常値1の場合、nullが返ってくること', () {
      final actual = Validator.getEmailRegValidatorMessage(successTestCase1);
      expect(actual, null);
    });
    test('正常値2の場合、nullが返ってくること', () {
      final actual = Validator.getEmailRegValidatorMessage(successTestCase2);
      expect(actual, null);
    });
    test('異常値1の場合、「有効なメールアドレスを入力して下さい」の文字列が返ってくること', () {
      final actual = Validator.getEmailRegValidatorMessage(errorTestCase1);
      expect(actual, '有効なメールアドレスを入力して下さい');
    });
    test('異常値2の場合、「有効なメールアドレスを入力して下さい」の文字列が返ってくること', () {
      final actual = Validator.getEmailRegValidatorMessage(errorTestCase2);
      expect(actual, '有効なメールアドレスを入力して下さい');
    });
  });
  group('getPartnerEmailValidatorMessage', () {
    const loginUserEmail = 'loginuser@loginuser.com';
    const successTestCase1 = 'test@test.co.jp';
    const successTestCase2 = 'test@test.jp';
    const errorTestCase1 = 'test@test.';
    const errorTestCase2 = 'test';
    test('正常系 空文字の場合、nullが返ってくること', () {
      final actual = Validator.getPartnerEmailValidatorMessage('', loginUserEmail);
      expect(actual, null);
    });
    test('正常系 nullの場合、nullが返ってくること', () {
      final actual = Validator.getPartnerEmailValidatorMessage(null, loginUserEmail);
      expect(actual, null);
    });
    test('正常値1の場合、nullが返ってくること', () {
      final actual = Validator.getPartnerEmailValidatorMessage(successTestCase1, loginUserEmail);
      expect(actual, null);
    });
    test('正常値2の場合、nullが返ってくること', () {
      final actual = Validator.getPartnerEmailValidatorMessage(successTestCase2, loginUserEmail);
      expect(actual, null);
    });
    test('異常系 valueとloginUserEmailの値が同じの場合、「ご自身のメールアドレスは入力出来ません」の文字列が返ってくること', () {
      final actual = Validator.getPartnerEmailValidatorMessage(loginUserEmail, loginUserEmail);
      expect(actual, 'ご自身のメールアドレスは入力出来ません');
    });
    test('異常値1の場合、「有効なメールアドレスを入力して下さい」の文字列が返ってくること', () {
      final actual = Validator.getPartnerEmailValidatorMessage(errorTestCase1, loginUserEmail);
      expect(actual, '有効なメールアドレスを入力して下さい');
    });
    test('異常値2の場合、「有効なメールアドレスを入力して下さい」の文字列が返ってくること', () {
      final actual = Validator.getPartnerEmailValidatorMessage(errorTestCase2, loginUserEmail);
      expect(actual, '有効なメールアドレスを入力して下さい');
    });
  });
  group('getPasswordValidatorMessage', () {
    test('正常系 パスワードの文字数が6文字未満の場合、「パスワードは6文字以上で入力してください」の文字列が返ってくること', () {
      final actual = Validator.getPasswordValidatorMessage('123456');
      expect(actual, null);
    });
    test('異常系 nullの場合、「パスワードの入力は必須です」が返ってくること', (){
      final actual = Validator.getPasswordValidatorMessage(null);
      expect(actual, 'パスワードの入力は必須です');
    });
    test('異常系 空文字の場合、「パスワードの入力は必須です」が返ってくること', (){
      final actual = Validator.getPasswordValidatorMessage('');
      expect(actual, 'パスワードの入力は必須です');
    });
    test('異常系 パスワードの文字数が6文字未満の場合、「パスワードは6文字以上で入力してください」が返ってくること', () {
      final actual = Validator.getPasswordValidatorMessage('12345');
      expect(actual, 'パスワードは6文字以上で入力してください');
    });
  });
}