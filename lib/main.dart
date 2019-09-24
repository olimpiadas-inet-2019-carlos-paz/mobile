import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:convert';
import 'package:muvision/widgets/exposition.dart';
import 'package:muvision/widgets/ShapesPainter.dart';
import 'package:muvision/expositionModel.dart';

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
        await http.get("http://192.168.43.104:8000/api/expositions/" + barcode);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      var data = ExpositionModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Exposition(
                  name: data.name,
                  creationDate: data.creationDate,
                  description: data.description,
                  imgUrl: data.imgUrl,
                )),
      );
      setState(() {
        isLoading = false;
        list = list;
      });
    } else {
      throw Exception('Error');
    }
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
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
                    'Muvision',
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
                        height: 250,
                        width: 300,
                        child: FlareActor(
                          'lib/assets/Scaner.flr',
                          animation: 'Movendo Celular v2',
                        ),
                      ),
                      Container(
                        child: AspectRatio(
                          aspectRatio: 2 / 1,
                          child: RaisedButton(
                            color: Color.fromRGBO(253, 216, 53, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  MdiIcons.qrcodeScan,
                                  size: 56.0,
                                ),
                                Text(
                                  'Escanear codigo',
                                  style: TextStyle(
                                    fontSize: 32.0,
                                  ),
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            onPressed: () {
                              barcodeScanning();
                            },
                          ),
                        ),
                      ),
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
