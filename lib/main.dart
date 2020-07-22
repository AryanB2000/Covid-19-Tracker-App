import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Covid-19 Tracker',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Covid-19 Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String value;

  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  void Getdata(String text) async {
    var response =
        await http.get('https://api.covidindiatracker.com/state_data.json');
    List data = jsonDecode(response.body);
    for (var i = 0; i < data.length; i++) {
      if (data[i]['state'] == text) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondScreen(
              active: data[i]['active'],
              recovered: data[i]['recovered'],
              deaths: data[i]['deaths'],
            ),
          ),
        );
        myController.clear();
        break;
      }
    }
  }

  _printLatestValue() {
    Getdata(myController.text);
  }

  @override
  void initState() {
    myController.addListener(_printLatestValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.white30,
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  controller: myController,
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration.collapsed(
                    hintText: "Enter name of state",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                myController.clear();
              },
              padding: EdgeInsets.all(10.0),
              child: Text("Check Cases"),
              textColor: Colors.white,
              color: Colors.red,
              elevation: 5.0,
              hoverColor: Colors.red.shade100,
              highlightColor: Colors.lightGreenAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final int active;
  final int recovered;
  final int deaths;
  SecondScreen({Key key, @required this.active, this.recovered, this.deaths})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid-19 Tracker'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Text(
            " Active cases: $active \n\n Recovered cases: $recovered \n\n Deaths: $deaths",
            style: TextStyle(fontSize: 24, color: Colors.red.shade400),
          ),
        ),
      ]),
    );
  }
}
