import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:volume/volume.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Future<void> _launched;
  static const streamUrl =
      "http://radyotelevizyon2.bozok.edu.tr:8030/;stream.mp3";

  bool isPlaying;
  bool isLoad = false;
  bool isdarkThemeEnabled = true;
  bool isTimer = true;

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
        isTimer = false;
      }
      if (state == AppLifecycleState.paused) {
        print('Lifecycle :  Paused');
        isTimer = true;
        Timer(Duration(hours: 1), () {
          if (isTimer) {
            audioStop();
          }
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
      color: Colors.white,
      title: 'Bozok FM',
      theme: isdarkThemeEnabled ? ThemeData.light() : ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(
              color: isdarkThemeEnabled ? Colors.black : Colors.red[900]),
          title: Text(
            'Bozok FM',
            style: TextStyle(
                color: isdarkThemeEnabled ? Colors.black : Colors.red[900]),
          ),
          backgroundColor: isdarkThemeEnabled
              ? Colors.red[900]
              : ThemeData.dark().canvasColor,
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
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          isdarkThemeEnabled
                              ? 'assets/images/bozokfm_logo_light_back_clean.png'
                              : 'assets/images/bozokfm_logo_for_dark_back_clean.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: isdarkThemeEnabled ? Colors.white54 : Colors.black12,
                ),
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.perm_device_information,
                  color: isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                ),
                title: Text(
                  'Kurumsal',
                  style: TextStyle(
                    color:
                        isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                ),
                children: <Widget>[
                  ExpansionTile(
                    title: Text(
                      'Biz Kimiz',
                      style: TextStyle(
                        color: isdarkThemeEnabled
                            ? Colors.black87
                            : Colors.red[900],
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_drop_down,
                      color:
                          isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                    ),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Yozgat Bozok Üniversitesi bünyesinde 2019 yılında yayın hayatına başlayan 107.0 Bozok FM kesintisiz yayın ve canlı yayınlarıyla dinleyicilerine kaliteli yayınlar sunmaktadır",
                            style: TextStyle(
                              color: isdarkThemeEnabled
                                  ? Colors.black87
                                  : Colors.red[900],
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.contact_mail,
                  color: isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                ),
                title: Text(
                  'İletişim',
                  style: TextStyle(
                    color:
                        isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                ),
                children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Takipte Kalın...',
                            style: TextStyle(
                              fontSize: 36,
                              color: isdarkThemeEnabled
                                  ? Colors.black87
                                  : Colors.red[900],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FlatButton(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FaIcon(FontAwesomeIcons.globe,
                                      color: isdarkThemeEnabled
                                          ? Colors.black87
                                          : Colors.red[900]),
                                  Text(
                                    'Web Sitemiz',
                                    style: TextStyle(
                                      color: isdarkThemeEnabled
                                          ? Colors.black87
                                          : Colors.red[900],
                                    ),
                                  ),
                                ]),
                            onPressed: () => setState(() {
                              _launched = _launchInBrowser(
                                  'http://bozok.edu.tr/radyo.aspx');
                            }),
                          ),
                          FlatButton(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FaIcon(FontAwesomeIcons.twitter,
                                      color: isdarkThemeEnabled
                                          ? Colors.black87
                                          : Colors.red[900]),
                                  Text(
                                    '@bozok_fm',
                                    style: TextStyle(
                                      color: isdarkThemeEnabled
                                          ? Colors.black87
                                          : Colors.red[900],
                                    ),
                                  ),
                                ]),
                            onPressed: () => setState(() {
                              _launched = _launchInBrowser(
                                  'https://twitter.com/bozok_fm');
                            }),
                          ),
                          FlatButton(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FaIcon(FontAwesomeIcons.instagram,
                                      color: isdarkThemeEnabled
                                          ? Colors.black87
                                          : Colors.red[900]),
                                  Text(
                                    '@107bozokfm',
                                    style: TextStyle(
                                      color: isdarkThemeEnabled
                                          ? Colors.black87
                                          : Colors.red[900],
                                    ),
                                  ),
                                ]),
                            onPressed: () => setState(() {
                              _launched = _launchInBrowser(
                                  'https://www.instagram.com/107bozokfm/');
                            }),
                          ),
                        ],
                      ))
                ],
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.info,
                  color: isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                ),
                title: Text(
                  'Geliştirici',
                  style: TextStyle(
                    color:
                        isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                ),
                children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Bu proje Yozgat Bozok Üniversitesi öğrencilerinden Celal KUTLUER tarafından, Flutter yazılım geliştirme kiti kullanılarak cross-platform olarak Android ve İOS da çalıştırılabilir şekilde geliştirilmiştir.",
                            style: TextStyle(
                              color: isdarkThemeEnabled
                                  ? Colors.black87
                                  : Colors.red[900],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Proje kaynak kodlarına https://github.com/celalkutluer/bozok_radyo adresinden erişilebilir.",
                            style: TextStyle(
                              color: isdarkThemeEnabled
                                  ? Colors.black87
                                  : Colors.red[900],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.warning,
                  color: isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                ),
                title: Text(
                  'Notlar',
                  style: TextStyle(
                    color:
                        isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: isdarkThemeEnabled ? Colors.black87 : Colors.red[900],
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Uygulama ekran kilidi vb. gibi durumlar ile pasife düştükten 1 saat sonra batarya ve mobil veri kullanımı düşünülerek otomatik kapanacak şekilde ayarlanmıştır. Sağlıkla kullanınız.",
                      style: TextStyle(
                        color: isdarkThemeEnabled
                            ? Colors.black87
                            : Colors.red[900],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
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
                        activeColor:
                            isdarkThemeEnabled ? Colors.black : Colors.red[900],
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

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
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
