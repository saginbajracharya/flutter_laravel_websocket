import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
// ignore: depend_on_referenced_packages
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  static const List events = [
    'connect',
    'connect_error',
    'connect_timeout',
    'connecting',
    'disconnect',
    'error',
    'reconnect',
    'reconnect_attempt',
    'reconnect_failed',
    'reconnect_error',
    'reconnecting',
    'ping',
    'pong'
  ];

  late socket_io.Socket socket;
  final serverUrl = 'http://192.168.1.106:6001';

  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    socket = socket_io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Connect to the server
    socket.connect();

    socket.on('connect', (_) {
      setState(() {
        isConnected = true;
      });
    });

    socket.on('disconnect', (_) {
      setState(() {
        isConnected = false;
      });
    });

    socket.on('error', (error) {
      if (kDebugMode) {
        print('Error during connection: $error');
      }
    });

    socket.on('home', (data) {
      if (kDebugMode) {
        print('Received message: $data');
      }
    });

    socket.on('event', (data) {
      if (kDebugMode) {
        print(data);
      }
    });

    socket.on('fromServer', (_) {
      if (kDebugMode) {
        print(_);
      }
    });
  }

  @override
  void dispose() {
    // Disconnect the socket when disposing of the widget.
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(events);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async{
                socket.connect();
              },
              child: const Text('CONNECT'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async{
                socket.emit('home', 'Hello from Flutter');
              },
              child: const Text('Send Message'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async{
                socket.disconnect();
              },
              child: const Text('DISCONNECT'),
            ),
          ],
        ),
      ),
    );
  }
}
