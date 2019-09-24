import 'package:flutter/material.dart';

class Exposition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("expo"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {},
        ),
      ),
    );
  }
}
