import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Salted SHA-256 PIN hashing. Stored format: `sha256\$<salt-b64>\$<hash-hex>`.
/// Legacy plaintext PINs (no prefix) are still verifiable and get hashed
/// the next time the profile is serialized.
class PinHasher {
  static const String _prefix = 'sha256\$';

  static bool isHashed(String stored) => stored.startsWith(_prefix);

  static String hash(String pin, {List<int>? salt}) {
    final s =
        salt ?? List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final digest = sha256.convert([...s, ...utf8.encode(pin)]);
    return '$_prefix${base64Encode(s)}\$$digest';
  }

  static bool verify(String pin, String stored) {
    if (!isHashed(stored)) return _constEq(pin, stored);
    final parts = stored.split('\$');
    if (parts.length != 3) return false;
    final salt = base64Decode(parts[1]);
    return _constEq(hash(pin, salt: salt), stored);
  }

  static bool _constEq(String a, String b) {
    if (a.length != b.length) return false;
    var r = 0;
    for (var i = 0; i < a.length; i++) {
      r |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return r == 0;
  }
}
