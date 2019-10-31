import 'package:flutter/material.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    /*
      Here is the code for https://json.generator.com:
      
      [
        '{{repeat(50)}}',
        {
          index:'{{index(0)}}',
          about:'Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula. Quisque velit nisi, pretium ut lacinia in, elementum id enim. Sed porttitor lectus nibh. Vivamus magna justo, lacinia eget consectetur sed, convallis at tellus.',
          email:'{{email([random])}}',
          name:'{{firstName()}} {{surname()}}',
          picture:'https://randomuser.me/api/portraits/men/{{index(0)}}.jpg'
        }
      ]
    */
    var data = await http
        .get('http://www.json-generator.com/api/json/get/ceDTBYcMEi?indent=2');
    var jsonData = json.decode(data.body);
    List<User> users = [];

    for (var u in jsonData) {
      User user = User(
        u["index"],
        u["about"],
        u["name"],
        u["email"],
        u["picture"],
      );

      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Loading...'),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data[index].picture),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new DetailsPage(snapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DetailsPage extends StatelessWidget {
  final User user;

  DetailsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(50.0),
              child: Image.network(user.picture, height: 100.00, width: 100.00),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.00),
            child: Column(
              children: <Widget>[
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
                Text(user.email),
                Text(user.about)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class User {
  final int index;
  final String about;
  final String name;
  final String email;
  final String picture;

  User(this.index, this.about, this.name, this.email, this.picture);
}
