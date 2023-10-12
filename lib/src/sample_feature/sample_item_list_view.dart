import 'dart:developer';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:laravel_flutter_pusher/laravel_flutter_pusher.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';

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
  var options = PusherOptions(
    host: '192.168.1.106',
    port: 6001,
    encrypted: false,
    cluster: 'ap2'
  );
  late LaravelFlutterPusher pusher;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    pusher = LaravelFlutterPusher("0d839545946ce754eb6c", options, enableLogging: true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Socket Connection'),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            //Connection Status
            Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            //Connect Button
            TextButton(
              onPressed: () async{
                pusher.connect().then((value) {
                  setState(() {
                    isConnected=true;
                  });
                });
              },
              child: const Text('CONNECT'),
            ),
            const SizedBox(height: 10),
            //Disconnect Button
            TextButton(
              onPressed: () async{
                pusher.disconnect().then((value) {
                  setState(() {
                    isConnected=false;
                  });
                });
              },
              child: const Text('DISCONNECT'),
            ),
            const SizedBox(height: 10),
            //Suscribe Button
            TextButton(
              onPressed: () async{
                pusher.subscribe('home').bind('event', (event) {
                  log('event =>$event');
                });
              },
              child: const Text('Suscribe Home CHANNEL'),
            ),
            //UnSubscribe Button
            TextButton(
              onPressed: () async{
                pusher.unsubscribe('home');
              },
              child: const Text('Unsubscribe Home CHANNEL'),
            ),
            const SizedBox(height: 10),
            //Send Message Button
            TextButton(
              onPressed: () async{
                pusher.unsubscribe('home');
                pusher.subscribe('home').trigger("AppEventsNewEvent").then((value){
                  log("message result ====> $value");
                });
              },
              child: const Text('SendMessage TO CHANNEL HOME'),
            ),
          ],
        ),
      ),
    );
  }
}
