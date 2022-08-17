import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../app/app.logger.dart';

abstract class SecureStorageService {
  Future<String?> getToken();
  Future<void> storeToken({String? token});
  Future<void> deleteToken();
}

class SecureStorageServiceImpl implements SecureStorageService {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  static String tokenKey = 'tokenKey';
  final log = getLogger('SecureStorageService');
  @override
  Future<void> deleteToken() async {
    log.i('deleting token');
    return await storage.delete(key: tokenKey);
  }

  @override
  Future<String?> getToken() async {
    log.i('getting token');
    return await storage.read(key: tokenKey);
  }

  @override
  Future<void> storeToken({String? token}) async {
    log.i('writing token');
    return await storage.write(key: tokenKey, value: token);
  }
}
