// ConnectivityState.dart
abstract class ConnectivityState {}

class InitialConnectivityState extends ConnectivityState {}

class InternetConnected extends ConnectivityState {
  final bool isConnected;
  InternetConnected(this.isConnected);
}

class InternetDisconnected extends ConnectivityState {}
