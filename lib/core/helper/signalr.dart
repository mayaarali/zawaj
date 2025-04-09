import 'dart:developer';

import 'package:signalr_core/signalr_core.dart';
import 'package:zawaj/core/constants/end_points.dart';

/*
class SignalR {
  static HubConnection? connection;
  static Future<void> connectAndStart() async {
    final connection = HubConnectionBuilder()
        .withUrl(
            EndPoints.hubURL,
            HttpConnectionOptions(
              logging: (level, message) => print(message),
            ))
        .build();
    // await connection.start();
    connection.on('ReceiveMessage', (message) {
      //  final sender = message[0].toString();
      //final message = message[1].toString();
      print(message.toString());
    });

    try {
      await connection.start();
      print('SignalR connection established');
    } catch (e) {
      print('Error establishing SignalR connection: $e');
    }
  }

//await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);
/*
static Future<void> sendMessage(String receiverId, String message) async {
    final endpointUrl = 'https://zawaj.somee.com/api/Chat/SendMessage'; // Endpoint URL

    if (connection?.state == HubConnectionState.connected) {
      try {
        final queryParams = {'receiverId': receiverId, 'message': message};
        await connection?.invoke('SendMessage', args: [queryParams]);
        print('Message sent: $message');
      } catch (e) {
        print('Error sending message: $e');
      }
    } else {
      print('SignalR connection is not established.');
    }
  }
  */
}
*/

/*
class SignalRService {
  static Future<void> connectAndStart() async {
    final connection = HubConnectionBuilder()
        .withUrl(
          EndPoints.hubURL,
            HttpConnectionOptions(
              logging: (level, message) => print(message),
            ))
        .build();

    await connection.start();

    connection.on('ReceiveMessage', (message) {
      print(message.toString());
    });

    //await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);
  }
}

*/
/*
class SignalRService {
  static HubConnection? connection;

  static Future<void> connectAndStart() async {
    try {
      final connection = HubConnectionBuilder()
          .withUrl(
              EndPoints.hubURL,
              HttpConnectionOptions(
                logging: (level, message) => print(message),
                
               // timeout: Duration(seconds: 30),
              ))
          .build();

      connection.on('ReceiveMessage', (message) {
        print(message.toString());
        print("nada w mayar");
      });

      try {
        await connection.start();
        print('SignalR connection established');
      } catch (e) {
        print('Error establishing SignalR connection: $e');
      }

      // Pass the connection to the chat screen
      //ChatScreen.setSignalRConnection(connection);
    } catch (e) {
      print('Error establishing SignalR connection: $e');
    }
  }
}
*/
import 'dart:async';

import 'package:zawaj/features/setup_account/data/models/params_model.dart';

class SignalRService {
  static HubConnection? connection;
  static Completer<void>? connectionCompleter;

  static Future<void> connectAndStart() async {
    try {
      connection = HubConnectionBuilder().withUrl(EndPoints.hubURL,
          HttpConnectionOptions(
        logging: (level, message) {
          print('iam in loggging');
          print(message);
          print(MessageType.invocation);
          print(level);
        },
      )).build();
      log('staaaaaaate is========>${connection!.state!}');
/*
      print('staaaaaaate is========>' + connection!.state!.toString());
      connectionCompleter = Completer<void>();
      await connection!.invoke('SendMessage', args: [
        'adc5f6f6-c105-4505-97d9-15dfcdac7ba6',
        '1494eb24-50a3-4f9b-8dfa-a66ebdf31854',
        'Says hi!'
      ]).then((value) {
        print('oooooooooops==>${value}');
      }).onError((error, stackTrace) {
        print('errrrrrrrrrrrr${error}');
      });
      connection?.on('GetOrCreateChat', (message) {
        print(message.toString());
        print("nada w mayar");
      });
*/
      await connection?.start();

      // await connection!.start()!.then((value) {
      //   print('connected successfully asmaa');
      //   return value;
      // }).catchError((e) {
      //   print('connected failed asmaa');
      // });

      connection!.on('ReceiveMessage', (message) {
        print('receive mesg :: ${message.toString()}');
      });

      await connection?.invoke('SendMessage', args: ['Bob', 'Says hi!']);

      //.then((data) => data.invoke())

      // Set a timeout duration
      const timeoutDuration = Duration(seconds: 500);

      // Start the timeout countdown
      Timer(timeoutDuration, () {
        if (!connectionCompleter!.isCompleted) {
          connectionCompleter!
              .completeError(TimeoutException('Connection timeout'));
        }
      });

      await connectionCompleter?.future;
      log('SignalR connection established');

      // Pass the connection to the chat screen
      //  ChatScreen.setSignalRConnection(connection!);
    } catch (e) {
      log('Error establishing SignalR connection: $e');
      // Handle the error here (e.g., display an error message, retry connection, etc.)
    }
  }
}
