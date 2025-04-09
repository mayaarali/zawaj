import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info.dart';

class NetworkInfoImp extends NetworkInfo{
  InternetConnectionChecker internetConnectionChecker ;
  NetworkInfoImp({required this.internetConnectionChecker});
  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}