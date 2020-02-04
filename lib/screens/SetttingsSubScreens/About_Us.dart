import 'package:flutter/material.dart';
import 'package:music_player_demo/models/SongsModel.dart';
import 'package:provider/provider.dart';
import '../MusicLibrary.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  SongsModel model;

  @override
  Widget build(BuildContext context) {
    model = Provider.of<SongsModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AppBar(
            leading: IconButton(
              iconSize: 25.0,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            centerTitle: false,
            title: Text("About", style: Theme.of(context).textTheme.display1),
          ),
          Padding(
              padding: EdgeInsets.only(top: height * 0.07),
              child: Center(child: Text("About US",style: TextStyle(fontSize: 25),)))
        ],
      ),
    );
  }
}


