import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'events.dart';
import 'states.dart';

// class InternetBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
//   final Connectivity connectivity;
//   late StreamSubscription connectivitySubscription;
//    List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

//   InternetBloc({required this.connectivity}) : super(InitialConnectivityState()) {
//     on<ListenConnectivity>((event, emit) async {
//       await _listenConnection(emit);
//     });

//     on<ConnectivityChanged>((event, emit) async {
//       if (event.isConnected) {
//         debugPrint('Internet Connected');
//         emit(InternetConnected());
//       } else {
//         debugPrint('Internet Disconnected');
//         emit(InternetDisconnected());
//       }
//     });

//     // Check initial connectivity status
//     checkInitialConnectivity();
//   }

//   Future<void> _listenConnection(Emitter<ConnectivityState> emit) async {
//     connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
//       add(ConnectivityChanged(result != ConnectivityResult.none));
//     });
//   }

//   // New method to check initial connectivity
//   void checkInitialConnectivity() async {
//     var result = await connectivity.checkConnectivity();
//     add(ConnectivityChanged(result != ConnectivityResult.none));
//   }

//   @override
//   Future<void> close() {
//     connectivitySubscription.cancel();
//     return super.close();
//   }
// }

// Connectivity Bloc
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityBloc() : super(InitialConnectivityState()) {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      bool isConnected = await _hasInternetConnection(result);
      add(ConnectivityChanged(isConnected));
    });

    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(InternetConnected(event.isConnected));
      } else {
        emit(InternetDisconnected());
      }
    });
  }

  Future<bool> _hasInternetConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
