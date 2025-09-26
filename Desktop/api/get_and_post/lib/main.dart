import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Get(), title: "abebe");
  }
}

class Get extends StatefulWidget {
  const Get({super.key});

  @override
  State<Get> createState() => _GetState();
}

class _GetState extends State<Get> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  void initState() {
    super.initState();
  }

  Future<void> Submit(String title, String body) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),

      body: json.encode({title: title, body: body}),
      headers: {'Content-type': 'application/json'},
    );
    if (response.statusCode == 201) {
      print("posted successfully");
    } else {
      throw Exception("error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("goro")),
      body: Column(
        children: [
          TextField(controller: title),
          SizedBox(height: 20),
          TextField(controller: body),
          TextButton(
            onPressed: () {
              Submit(title.text, body.text);
            },
            child: Text("submit"),
          ),
        ],
      ),
    );
  }
}
