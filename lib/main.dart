import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _initialisation = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialisation,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.error.toString()),
          );
        if (snapshot.connectionState == ConnectionState.done)
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soil Monitoring App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: StreamBuilder(
          stream: FirebaseDatabase.instance.reference().onValue,
          builder: (context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData && snapshot.data.snapshot?.value != null) {
              dynamic temp = snapshot.data.snapshot.value['temp'];
              dynamic ph = snapshot.data.snapshot.value['ph'];
              dynamic moistureLevel =
                  snapshot.data.snapshot.value['moisture_level'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'temp',
                    style: TextStyle(color: temp > 35 ? Colors.red : Colors.black54),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "$temp",
                    style: TextStyle(
                      fontSize: 22,
                      color: temp > 35 ? Colors.red : Colors.black,
                    ),
                  ),
                  temp > 35
                      ? Text(
                          'Soil temperature too high. Take measures to cool it',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'ph',
                    style: TextStyle(
                      color: ph > 7.5 ? Colors.red : Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "$ph",
                    style: TextStyle(
                      fontSize: 22,
                      color: ph > 7.5 ? Colors.red : Colors.black,
                    ),
                  ),
                  ph > 7.5
                      ? Text('Soil ph too high. Take measures to lower it')
                      : Container(),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Moisture Level',
                    style: TextStyle(
                      color: moistureLevel > 350 ? Colors.red : Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "$moistureLevel",
                    style: TextStyle(
                      fontSize: 22,
                      color: moistureLevel > 350 ? Colors.red : Colors.black,
                    ),
                  ),
                  moistureLevel > 350
                      ? Text(
                          'Moisture level too high. Take measures to reduce it',
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                ],
              );
            }
            if (snapshot.hasError) return Text(snapshot.error);
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
