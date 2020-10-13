import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:volume/volume.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  SharedPreferences preferences;

  bool isdarkThemeEnabled = false;
  int uykuZamaniCins = 1;
  double uykuZamaniSure = 1.0;

  Future getLocalData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isdarkThemeEnabled = preferences.getBool('isdarkThemeEnabled') ?? false;
      uykuZamaniCins = preferences.getInt('uykuZamaniCins') ?? 1;
      uykuZamaniSure = preferences.getDouble('uykuZamaniSure') ?? 1.0;
    });
  }

  Future<void> _launched;
  static const streamUrl =
      "http://radyotelevizyon2.bozok.edu.tr:8030/;stream.mp3";

  bool isPlaying;
  bool isLoad = false;
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
        if (uykuZamaniCins == 1) {
          //dakika
          Timer(
              Duration(
                  minutes: uykuZamaniSure == 0 ? 1 : uykuZamaniSure.toInt()),
              () {
            if (isTimer) {
              audioStop();
            }
            isLoad = !isLoad;
          });
        } else if (uykuZamaniCins == 2) {
          //saat
          Timer(
              Duration(
                  hours: uykuZamaniSure == 0
                      ? 1
                      : uykuZamaniSure >= 24 ? 24 : uykuZamaniSure.toInt()),
              () {
            if (isTimer) {
              audioStop();
            }
            isLoad = !isLoad;
          });
        }
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
    getLocalData();
    return new MaterialApp(
      color: Colors.white,
      title: 'Bozok FM',
      theme: isdarkThemeEnabled ? ThemeData.light() : ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(color: myColor()),
          title: myText('Bozok FM'),
          backgroundColor: isdarkThemeEnabled
              ? Colors.red[900]
              : ThemeData.dark().canvasColor,
          actions: [mySwitch()],
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
                  color: myColor(),
                ),
                title: myText('Kurumsal'),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: myColor(),
                ),
                children: <Widget>[
                  ExpansionTile(
                    title: myText('Biz Kimiz'),
                    trailing: Icon(
                      Icons.arrow_drop_down,
                      color: myColor(),
                    ),
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: myText(
                              "Yozgat Bozok Üniversitesi bünyesinde 2019 yılında yayın hayatına başlayan 107.0 Bozok FM kesintisiz yayın ve canlı yayınlarıyla dinleyicilerine kaliteli yayınlar sunmaktadır"))
                    ],
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.contact_mail,
                  color: myColor(),
                ),
                title: myText('İletişim'),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: myColor(),
                ),
                children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Takipte Kalın...',
                            style: TextStyle(
                              color: myColor(),
                              fontSize: 36.0,
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
                                      color: myColor()),
                                  myText('Web Sitemiz'),
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
                                      color: myColor()),
                                  myText('@bozok_fm'),
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
                                      color: myColor()),
                                  myText('@107bozokfm'),
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
                  color: myColor(),
                ),
                title: myText('Geliştirici'),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: myColor(),
                ),
                children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          myText(
                              "Bu proje Yozgat Bozok Üniversitesi öğrencilerinden Celal KUTLUER tarafından, Flutter yazılım geliştirme kiti kullanılarak cross-platform olarak Android ve İOS da çalıştırılabilir şekilde geliştirilmiştir."),
                          SizedBox(
                            height: 10,
                          ),
                          myText(
                              "Proje kaynak kodlarına https://github.com/celalkutluer/bozok_radyo adresinden erişilebilir."),
                        ],
                      ))
                ],
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.settings,
                  color: myColor(),
                ),
                title: myText('Ayarlar'),
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: myColor(),
                ),
                children: [
                  Row(children: <Widget>[
                    Expanded(child: Divider()),
                    myText('Karanlık Mod'),
                    Expanded(child: Divider()),
                  ]),
                  mySwitch(),
                  Row(children: <Widget>[
                    Expanded(child: Divider()),
                    myText('Uyku Zamanı'),
                    Expanded(child: Divider()),
                  ]),
                  DropdownButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: myColor(),
                      ),
                      value: uykuZamaniCins,
                      items: [
                        DropdownMenuItem(
                          child: myText("Yok"),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: myText("Dakika"),
                          value: 1,
                        ),
                        DropdownMenuItem(child: myText('Saat'), value: 2),
                      ],
                      onChanged: (value) {
                        setState(() {
                          uykuZamaniCins = value;
                          preferences.setInt('uykuZamaniCins', uykuZamaniCins);
                          int zaman = uykuZamaniSure.toInt();
                          Fluttertoast.showToast(
                              msg: uykuZamaniCins == 0
                                  ? 'Uyku zamanı ayarlanmadı.'
                                  : uykuZamaniCins == 2
                                      ? 'Uyku zamanı $zaman saat olarak ayarlandı.'
                                      : 'Uyku zamanı $zaman dakika olarak ayarlandı.',
                              backgroundColor: Colors.transparent,
                              textColor: myColor());
                        });
                      }),
                  uykuZamaniCins == 0
                      ? SizedBox(
                          height: 2,
                        )
                      : Slider(
                          activeColor: myColor(),
                          value: uykuZamaniSure == 0
                              ? 1
                              : uykuZamaniCins == 2
                                  ? uykuZamaniSure > 24 ? 24 : uykuZamaniSure
                                  : uykuZamaniSure,
                          min: 0,
                          max: uykuZamaniCins == 2 ? 24 : 60,
                          divisions: uykuZamaniCins == 2 ? 24 : 12,
                          label: (uykuZamaniSure == 0
                                  ? 1
                                  : uykuZamaniCins == 2
                                      ? uykuZamaniSure > 24
                                          ? 24
                                          : uykuZamaniSure
                                      : uykuZamaniSure)
                              .round()
                              .toString(),
                          onChanged: (double value) {
                            setState(() {
                              uykuZamaniSure = value;
                              if (uykuZamaniSure == 0) {
                                uykuZamaniSure = 1;
                              }
                              if (uykuZamaniCins == 2 && uykuZamaniSure > 24) {
                                uykuZamaniSure = 24;
                              }
                              preferences.setDouble(
                                  'uykuZamaniSure', uykuZamaniSure);
                            });
                          },
                          onChangeEnd: (double v) {
                            setState(() {
                              int zaman = uykuZamaniSure.toInt();
                              Fluttertoast.showToast(
                                  msg: uykuZamaniCins == 0
                                      ? 'Uyku zamanı ayarlanmadı.'
                                      : uykuZamaniCins == 2
                                          ? 'Uyku zamanı $zaman saat olarak ayarlandı.'
                                          : 'Uyku zamanı $zaman dakika olarak ayarlandı.',
                                  backgroundColor: Colors.transparent,
                                  textColor: myColor());
                            });
                          },
                        ),
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
                        activeColor: myColor(),
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
                    color: myColor(),
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

  Color myColor() {
    return isdarkThemeEnabled ? Colors.black : Colors.red[900];
  }

  Widget myText(String data) {
    return Text(
      data,
      style: TextStyle(
        color: myColor(),
      ),
    );
  }

  Widget mySwitch() {
    return Switch(
      value: isdarkThemeEnabled,
      onChanged: (newDarkThemeEnabled) {
        setState(() {
          isdarkThemeEnabled = newDarkThemeEnabled;
          preferences.setBool('isdarkThemeEnabled', isdarkThemeEnabled);
          print('modun değişti');
        });
      },
      activeColor: Colors.black,
      inactiveThumbColor: Colors.red[900],
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