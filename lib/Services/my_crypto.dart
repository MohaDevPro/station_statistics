import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecryption {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));
  static encrypt.Encrypted encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }

  static decryptAES(encrypt.Encrypted text) {
    final decrypted = encrypter.decrypt(text, iv: iv);
    return decrypted;
  }
}
