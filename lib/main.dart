import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:volume/volume.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const streamUrl =
      "http://radyotelevizyon2.bozok.edu.tr:8030/;stream.mp3";

  bool isPlaying;
  bool isLoad = false;
  bool isdarkThemeEnabled = true;

  AudioManager audioManager;
  int maxVol, currentVol;
  ShowVolumeUI showVolumeUI = ShowVolumeUI.HIDE;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    audioStart();
    playingStatus();
    //
    audioManager = AudioManager.STREAM_SYSTEM;
    initAudioStreamType();
    updateVolumes();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.resumed) {
        print('Lifecycle :  resumed');
      }
      if (state == AppLifecycleState.paused) {
        print('Lifecycle :  Paused');
        Timer(Duration(hours: 1), () {
          audioStop();
          isLoad = !isLoad;
        });
      }
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    super.dispose();
    print(' dispose');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.red[700],
      title: 'Bozok FM',
      theme: isdarkThemeEnabled ? ThemeData.light() : ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: Text(
            'Bozok FM',
            style: TextStyle(
                color: isdarkThemeEnabled ? Colors.black : Colors.red[900]),
          ),
          backgroundColor: isdarkThemeEnabled ?  Colors.red[900]:ThemeData.dark().canvasColor,
          actions: [
            Switch(
              value: isdarkThemeEnabled,
              onChanged: (newDarkThemeEnabled) {
                setState(() {
                  isdarkThemeEnabled = newDarkThemeEnabled;
                });
              },
              activeColor: Colors.black,
              inactiveThumbColor: Colors.red[900],
            )
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
                    child: Image.asset(
                      isdarkThemeEnabled
                          ? 'assets/images/bozokfm_logo_light_back_clean.png'
                          : 'assets/images/bozokfm_logo_for_dark_back_clean.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                (currentVol != null || maxVol != null)
                    ? Slider(
                        activeColor: isdarkThemeEnabled ? Colors.black : Colors.red[900],
                        value: currentVol / 1.0,
                        divisions: maxVol,
                        max: maxVol / 1.0,
                        min: 0,
                        onChanged: (double d) {
                          setVol(d.toInt());
                          updateVolumes();
                        },
                      )
                    : Container(),
                FlatButton(
                  child: Icon(
                    isLoad
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 100,
                    color: isdarkThemeEnabled ? Colors.black : Colors.red[900],
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

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }

  Future<void> audioStop() async {
    await FlutterRadio.stop();
    print('Audio Stop');
  }

  Future<void> initAudioStreamType() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {});
  }

  setVol(int i) async {
    await Volume.setVol(i, showVolumeUI: showVolumeUI);
  }
}
