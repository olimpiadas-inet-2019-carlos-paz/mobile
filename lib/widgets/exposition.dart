import 'package:flutter/material.dart';

class Exposition extends StatelessWidget {
  const Exposition({Key key, this.name, this.description, this.creationDate}) : super(key: key);
  final String name;
  final String description;
  final String creationDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(fontSize: 30)),
      ),
      body: Center(
        child: Text(description, style: TextStyle(fontSize: 30),),
      ),
    );
  }
}


