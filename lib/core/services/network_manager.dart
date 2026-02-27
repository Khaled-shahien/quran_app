import 'package:connectivity_plus/connectivity_plus.dart';

/// Network Connectivity Manager
///
/// Handles network connectivity state and changes
class NetworkManager {
  final Connectivity _connectivity;

  NetworkManager({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Check current connectivity status
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Get current connectivity type
  Future<ConnectivityResult> getConnectivityType() async {
    return await _connectivity.checkConnectivity();
  }

  /// Listen to connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// Check if connected to WiFi
  Future<bool> isWifiConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.wifi;
  }

  /// Check if connected to mobile data
  Future<bool> isMobileConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.mobile;
  }

  /// Check if connected to ethernet
  Future<bool> isEthernetConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result == ConnectivityResult.ethernet;
  }

  /// Get network status as string
  Future<String> getNetworkStatus() async {
    final result = await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.none:
      default:
        return 'No Connection';
    }
  }
}
