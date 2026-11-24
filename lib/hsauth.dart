import 'dart:convert';
import 'package:http/http.dart' as http;

class UserData {
  String username = '';
  String ip = '';
  String hwid = '';
  String expiresAt = '';
}

class HSAuth {
  final String name;
  final String ownerId;
  final String secret;
  final String version;
  final String apiUrl;

  String sessionId = '';
  bool isInitialized = false;
  final UserData userData = UserData();

  HSAuth({
    required this.name,
    required this.ownerId,
    required this.secret,
    this.version = '1.0',
    this.apiUrl = 'https://auth.hsdevs.pro/api/1.3/',
  });

  Future<bool> init() async {
    try {
      final res = await http.post(Uri.parse(apiUrl), body: {
        'type': 'init',
        'name': name,
        'ownerid': ownerId,
        'ver': version,
      });

      final json = jsonDecode(res.body);
      if (json['success'] == true) {
        sessionId = json['sessionid'] ?? '';
        isInitialized = true;
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> login(String username, String pass) async {
    if (!isInitialized) await init();
    try {
      final res = await http.post(Uri.parse(apiUrl), body: {
        'type': 'login',
        'username': username,
        'pass': pass,
        'sessionid': sessionId,
        'name': name,
        'ownerid': ownerId,
      });

      final json = jsonDecode(res.body);
      if (json['success'] == true) {
        if (json['info'] != null) {
          userData.username = json['info']['username'] ?? username;
          userData.expiresAt = json['info']['expiry'] ?? '';
        }
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> license(String key) async {
    if (!isInitialized) await init();
    try {
      final res = await http.post(Uri.parse(apiUrl), body: {
        'type': 'license',
        'key': key,
        'sessionid': sessionId,
        'name': name,
        'ownerid': ownerId,
      });

      final json = jsonDecode(res.body);
      if (json['success'] == true) {
        if (json['info'] != null) {
          userData.username = json['info']['username'] ?? '';
          userData.expiresAt = json['info']['expiry'] ?? '';
        }
        return true;
      }
    } catch (_) {}
    return false;
  }
}
