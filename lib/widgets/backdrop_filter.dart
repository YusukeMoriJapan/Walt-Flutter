import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

main() async {
  runApp(ProviderScope(
    child: MaterialApp(
      home: BlurMultipleWidgetsPage(key: Key("homePage")),
    ),
  ));
}

class BlurMultipleWidgetsPage extends StatefulWidget {
  BlurMultipleWidgetsPage({required Key key}) : super(key: key);

  @override
  _BlurMultipleWidgetsState createState() => _BlurMultipleWidgetsState();
}

class _BlurMultipleWidgetsState extends State<BlurMultipleWidgetsPage> {
  final double _width = 350;
  final double _height = 300;
  int _imageIndex = 0;
  double _sigmaX = 0.0;
  double _sigmaY = 0.0;
  double _opacity = 0.0;

  final images = ["background1.jpg", "background2.jpg", "background3.jpg"];

  @override
  Widget build(BuildContext context) {
    print('rebuild with sigmaX=${_sigmaX.toStringAsFixed(2)}, '
        'sigmaY=${_sigmaY.toStringAsFixed(2)}, '
        'opacity=${_opacity.toStringAsFixed(2)}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Blur multiple widgets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _buildImageContainer(),
            SizedBox(height: 5),
            RaisedButton(
              child: Text('Next image'),
              onPressed: () {
                setState(() {
                  _imageIndex = (_imageIndex + 1) % images.length;
                });
              },
            ),
            SizedBox(height: 5),
            ..._buildBlurSigmaAndOpacity(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/${images[_imageIndex]}',
          width: _width,
          height: _height,
          fit: BoxFit.cover,
        ),
        FlutterLogo(size: 80, textColor: Colors.red),
        Container(
          width: _width,
          height: _height,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
            child: Container(
              color: Colors.black.withOpacity(_opacity),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _buildBlurSigmaAndOpacity() {
    return [
      Text('Change blur sigmaX: ${_sigmaX.toStringAsFixed(2)}'),
      Slider(
        min: 0,
        max: 10,
        value: _sigmaX,
        label: '$_sigmaX',
        onChanged: (value) {
          setState(() {
            _sigmaX = value;
          });
        },
      ),
      SizedBox(height: 5),
      Text('Change blur sigmaY: ${_sigmaY.toStringAsFixed(2)}'),
      Slider(
        min: 0,
        max: 10,
        value: _sigmaY,
        onChanged: (value) {
          setState(() {
            _sigmaY = value;
          });
        },
      ),
      SizedBox(height: 5),
      Text('Change blur opacity: ${_opacity.toStringAsFixed(2)}'),
      Slider(
        min: 0,
        max: 1,
        value: _opacity,
        onChanged: (value) {
          setState(() {
            _opacity = value;
          });
        },
      ),
    ];
  }
}
