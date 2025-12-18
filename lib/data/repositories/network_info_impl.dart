import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobile_app/domain/repositories/i_network_info.dart';

class NetworkInfoImpl implements INetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
