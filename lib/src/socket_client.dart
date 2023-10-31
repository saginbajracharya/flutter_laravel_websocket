import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:socket_io_client/socket_io_client.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class SocketClient extends StatefulWidget {
  const SocketClient({super.key});
  static const routeName = 'socket_client';

  @override
  State<SocketClient> createState() => _SocketClientState();
}

class _SocketClientState extends State<SocketClient> {
  TextEditingController messageCon = TextEditingController();
  final serverUrl = 'http://192.168.1.106:3001';
  late Socket socket; // Define a Socket instance

  @override
  void initState() {
    super.initState();
    // Connect to the Socket.io server
    socket = io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.on('connect', (_) {
      if (kDebugMode) {
        print('Connected to the server');
      }
      // You can emit events here or handle other actions upon connection.
    });
    socket.connect();
  }

  // Function to send a message to the server
  void sendMessage(String message) {
    socket.emit('event_name', message);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Socket Client'),
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                style: Theme.of(context).textTheme.bodyLarge,
                controller: messageCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background,
                  hintText: 'Enter Message',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: (){
                      messageCon.clear();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),
              OutlinedButton(
                onPressed:(){
                  // Send a message to the server
                  _sendHttpRequest(messageCon.text.trim());
                }, 
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)), // Adjust padding for height
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.lightBlue; // Color when pressed
                    }
                    return Colors.blue; // Default color
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Adjust border radius
                    ),
                  ),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(
                    color: Colors.white, // Text color
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }

  void _sendHttpRequest(message) async {
    final url = Uri.parse('$serverUrl/api/v1/forecast?count=$message');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('HTTP Request Success');
        print('Response data: ${response.body}');
      }
      // Handle the response as needed
    } else {
      if (kDebugMode) {
        print('HTTP Request Failed');
      }
    }
  }
}