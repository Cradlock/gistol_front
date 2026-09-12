

import 'dart:async';

import 'package:app_front/core/core.dart';
import 'package:app_front/core/errors/common.dart';
import 'package:app_front/features/auth/domain/errors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

class AppProvider extends ChangeNotifier {
  
  
  StreamSubscription<List<ConnectivityResult>>? _networkSub;
  
  bool _isConnected = true;
  bool get isConnected => _isConnected;


  Future<void> init() async {
    final initResult = await Connectivity().checkConnectivity();

    _updateNetworkStatus(initResult);

    _networkSub = Connectivity().onConnectivityChanged.listen(_updateNetworkStatus);
  } 
  

  void _updateNetworkStatus(List<ConnectivityResult> results) {
    final hasNetwork = !results.contains(ConnectivityResult.none);
    
    if (_isConnected != hasNetwork) {
      _isConnected = hasNetwork;
      notifyListeners();

      if (!hasNetwork) {
        ErrorHandler.handle(NoInternetException());   
      

      }
    }
  }
  
}
