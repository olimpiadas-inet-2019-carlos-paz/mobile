import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:convert';
import 'package:muvision/widgets/exposition.dart';
import 'package:muvision/widgets/ShapesPainter.dart';

import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Muvision',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Muvision'),
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
  String barcode;
  var list;
  var isLoading = false;

  _fetchData(barcode) async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get("http://192.168.43.104:8000/api/expositions/"+barcode);
    print(barcode);
    if (response.statusCode == 200) {
      list = json.decode(response.body)[0];
      print(list);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Exposition()),
      );
      setState(() {
        isLoading = false;
        list = list;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan(); // el resultado del qr (1,2,3,...)
      await _fetchData(barcode);
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomPaint(
          painter: ShapesPainter(),
          child: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AppBar(
                  title: Text(
                    'Muvison',
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.w700),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Para apreciar las obras en tu telefono, debes apuntar al codigo.",
                          style: TextStyle(fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'lib/assets/qr_code_example.png',
                              height: 200,
                            ),
                            Text(
                              'Ejemplo',
                              style: TextStyle(
                                  fontSize: 30, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          child: OutlineButton(
                        borderSide: BorderSide(color: Colors.black, width: 3),
                        padding: EdgeInsets.only(
                            right: 50, top: 25, bottom: 25, left: 50),
                        child: Text(list.toString() ?? 'No data',
                            style: TextStyle(fontSize: 30)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () {
                          barcodeScanning();
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
