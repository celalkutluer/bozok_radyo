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
  bool isLoad = false;
  bool darkThemeEnabled = true;

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
      title: 'Bozok FM',
      theme: darkThemeEnabled ? ThemeData.light() : ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Bozok FM'),
          backgroundColor: Colors.red[700],
          actions: [
            Switch(
                value: darkThemeEnabled,
                onChanged: (newDarkThemeEnabled) {
                  setState(() {
                    darkThemeEnabled = newDarkThemeEnabled;
                  });
                },activeColor: Colors.red[900],)
          ],
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
                  child: Image.asset(darkThemeEnabled ?
                    'assets/images/bozokfm_logo_light_back_clean.png':'assets/images/bozokfm_logo_for_dark_back_clean.png',
                    fit: BoxFit.contain,
                  ),
                )),
                FlatButton(
                  child: Icon(
                    isLoad
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 100,
                    color: isLoad ? Colors.black : Colors.red[700],
                  ),
                  onPressed: () {
                    isLoad = !isLoad;
                    FlutterRadio.playOrPause(url: streamUrl);
                    playingStatus();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
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
