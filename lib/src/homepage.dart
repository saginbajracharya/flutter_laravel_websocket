import 'package:flutter/material.dart';
import 'package:flutter_laravel_websocket/src/sample_feature/sample_item_list_view.dart';
import 'package:flutter_laravel_websocket/src/socket_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            OutlinedButton(
              onPressed:(){
                Navigator.restorablePushNamed(context, SocketClient.routeName);
              }, 
              child: const Text('socket_io_client')
            ),
            OutlinedButton(
              onPressed: (){
                Navigator.restorablePushNamed(context, SampleItemListView.routeName);
              }, 
              child: const Text('laravel_flutter_pusher')
            ),
          ],
        ),
      ),
    );
  }
}