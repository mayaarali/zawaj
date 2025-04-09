// ConnectivityEvent.dart
abstract class ConnectivityEvent {}

class ListenConnectivity extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;

  ConnectivityChanged(this.isConnected);
}
