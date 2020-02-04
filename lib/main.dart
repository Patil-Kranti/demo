import 'dart:async';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'models/BookmarkModel.dart';
import 'models/Now_Playing.dart';
import 'models/PlaylistRepo.dart';
import 'models/ProgressModel.dart';
import 'models/RecentsModel.dart';
import 'models/SongsModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/MainScreen.dart';
import 'models/ThemeModel.dart';

import 'models/Username.dart';
import 'screens/login.dart';
import 'screens/onboarding/Onboarding.dart';

void main(List<String> args) {
  var prov = ProgressModel();
  var rec = Recents();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<BookmarkModel>(
      create: (context) => BookmarkModel(),
    ),
    ChangeNotifierProvider<PlaylistRepo>(
      create: (context) => PlaylistRepo(),
    ),
    ChangeNotifierProvider<Username>(
      create: (context) => Username(),
    ),
    ChangeNotifierProvider<Recents>(
      create: (context) => rec,
    ),
    ChangeNotifierProvider<ProgressModel>(
      create: (context) => prov,
    ),
    ChangeNotifierProvider<SongsModel>(
      create: (context) => SongsModel(prov, rec),
    ),
    ChangeNotifierProvider<ThemeChanger>(create: (context) => ThemeChanger()),
    ChangeNotifierProvider<NowPlaying>(create: (context) => NowPlaying(false))
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SongsModel model;

  @override
  void initState() {
    MediaNotification.setListener('pause', () {
      setState(() {
        model.pause();
      });
    });

    MediaNotification.setListener('next', () {
      setState(() {
        model.player.stop();
        model.next();
        model.play();
      });
    });

    MediaNotification.setListener('prev', () {
      setState(() {
        model.player.stop();
        model.previous();
        model.play();
      });
    });

    MediaNotification.setListener('play', () {
      setState(() => model.play());
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    model.stop();
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<SongsModel>(context);
    ThemeChanger theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      home: Splash(),
      theme: theme.getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    bool _isLoggedIn = prefs.getBool('_isLoggedIn');

    if (_isLoggedIn ?? false) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    } else if (_seen) {
      SystemChrome.setEnabledSystemUIOverlays([]);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));
    } else {
      SystemChrome.setEnabledSystemUIOverlays([]);
      prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnBoarding()));
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
    checkFirstSeen();
  }
}
