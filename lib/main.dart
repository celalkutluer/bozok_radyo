import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_radio/flutter_radio.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const streamUrl =
      "http://radyotelevizyon2.bozok.edu.tr:8030/;stream.mp3";

  bool isPlaying;
  double radioVolume = 70;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.red[700],
          title: const Text('Bozok FM'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/bozokfm_logo_light_back_clean.png',
                  fit: BoxFit.contain,
                ),
              )),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.pause_circle_filled,
                      size: 66,
                    ),
                    onPressed: () {
                      FlutterRadio.playOrPause(url: streamUrl);
                      playingStatus();
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.play_circle_filled,
                      size: 66,
                      color:Colors.red[700]
                    ),
                    onPressed: () {
                      FlutterRadio.playOrPause(url: streamUrl);
                      playingStatus();
                    },
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.stop,
                      size: 66,
                    ),
                    onPressed: () {
                      FlutterRadio.playOrPause(url: streamUrl);
                      playingStatus();
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: 10,
              ), /*
              Text(
                'Check Playback Status: $isPlaying',
                style: TextStyle(fontSize: 25.0),
              )*/
            ],
          )),
        ),
      ),
    );
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }
}
