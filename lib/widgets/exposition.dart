import 'package:flutter/material.dart';

class Exposition extends StatelessWidget {
  const Exposition({Key key, this.name, this.description, this.creationDate, this.imgUrl})
      : super(key: key);
  final String name;
  final String description;
  final String creationDate;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: AppBar(
              title: Text(
                name,
                style: TextStyle(fontSize: 50),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
                  child: Image.network(
                   imgUrl,
                    scale: 1.5,
                  ),
                ),
                Container(
                    child: Center(
                      child: Text(creationDate, style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),),)
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text(description, style: TextStyle(fontSize: 22), textAlign: TextAlign.justify,),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
