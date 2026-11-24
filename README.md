# HS DEVS AUTH — Dart & Flutter SDK

Official client package for cross-platform Flutter applications.

## Usage

```dart
import 'package:hsauth/hsauth.dart';

final auth = HSAuth(name: 'AppName', ownerId: 'OwnerID', secret: 'Secret', version: '1.0');

void authenticate() async {
  if (await auth.license('XXXX-XXXX-XXXX-XXXX')) {
    print('Welcome, expires: ${auth.userData.expiresAt}');
  }
}
```
