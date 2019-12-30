import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http.get(
    'https://api.giphy.com/v1/gifs/trending?api_key=1p1RiLTyKpOMLK4lNIfluPhncrle9pPn&limit=4&rating=G',
    headers: {HttpHeaders.authorizationHeader: "1p1RiLTyKpOMLK4lNIfluPhncrle9pPn"},
  );

  if (response.statusCode == 200) { 
    // If the call to the server was successful, parse the JSON.
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final String type;
  final String id;
  final String title;
  final String rating;

  Post({this.type, this.id, this.title, this.rating});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      type: json['type'],
      id: json['id'],
      title: json['title'],
      rating: json['rating'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
Future<Post> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("${snapshot.data.title}");
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}