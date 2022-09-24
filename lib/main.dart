import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_data/send_info.dart';
import 'images.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  var myFabButton = Container(
    width: 200.0,
    height: 200.0,
    
    child: new RawMaterialButton(
      shape: new CircleBorder(),
      elevation: 0.0,
      child: Text('Quick Order'),
      onPressed: () {},
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Order App'),
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
            child: Image.asset(
              width: double.infinity,
              height: 170,
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return SendInfo();
          }));
        },
        label: Text(
          "Quick Order",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
