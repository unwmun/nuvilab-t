import 'dart:io';

import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      // Internet 연결 상태를 확인하기 위해 DNS lookup 시도
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
