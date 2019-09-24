import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

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

  Future barcodeScanning() async {
//imageSelectorGallery();

    try {
      String barcode = await BarcodeScanner.scan();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Camara(barcode: barcode)),
      );
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
                            borderSide: BorderSide(
                                color: Colors.black, width: 3),
                            padding: EdgeInsets.only(
                                right: 50, top: 25, bottom: 25, left: 50),
                            child: Text('Comenzar recorrido',
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

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color.fromRGBO(253, 216, 53, 1);

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    paint.color = Color.fromRGBO(255, 167, 38, 1);
    var path = Path();
    path.lineTo(0, 500);
    path.lineTo(size.width, 380);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Camara extends StatelessWidget {
  const Camara({Key key, this.barcode}) : super(key: key);
  final String barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(barcode),
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

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
