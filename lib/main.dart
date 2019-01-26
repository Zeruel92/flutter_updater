import 'package:flutter/material.dart';
import 'versionchecker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData.dark(),
    home: new AppUpdater(),
  ));
}

class AppUpdater extends StatefulWidget {
  @override
  _AppUpdaterState createState() => _AppUpdaterState();
}

class _AppUpdaterState extends State<AppUpdater> {
  VersionChecker versionChecker;
  String version;
  String buildn;

  @override
  void initState() {
    super.initState();
    version = "";
    buildn = "";
    versionChecker = new VersionChecker();
    _showUpdateWidget();
  }

  void _showUpdateWidget() async {
    await versionChecker.getLastVersion();

    setState(() {
      version = versionChecker.version;
      buildn = versionChecker.buildNumber;
    });

    if ((versionChecker.version != versionChecker.remoteVersion) ||
        (versionChecker.buildNumber != versionChecker.remoteBuildNumber)) {
      print(
          "Version : ${versionChecker.version}\nRemote: ${versionChecker.remoteVersion}");
      print(
          "BuildNumber : ${versionChecker.buildNumber}\nRemote: ${versionChecker.remoteBuildNumber}");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text("Aggiornamento disponibile!"),
              content: new Text(
                  "È disponibile un nuovo aggiornamento per l'app! Premi download per installarlo!"),
              actions: <Widget>[
                new RaisedButton(
                  child: new Text("Download"),
                  onPressed: _downloadUpdate,
                ),
                new RaisedButton(
                  child: new Text("Annulla"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            );
          });
    }
  }

  void _downloadUpdate() async {
    Response apk = await http.get('http://192.168.1.215:8080/download');
    final directory = await getApplicationDocumentsDirectory();
    var fileapk = new File('${directory.path}/apknew.apk');
    fileapk.writeAsBytesSync(apk.bodyBytes);
    OpenFile.open('${directory.path}/apknew.apk');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Prova di autoupdate"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Text("Versione $version+$buildn"),
            new Image.network(
                "https://italiancoders.it/wp-content/uploads/2017/12/flutter-1920x815.png")
          ],
        ),
      ),
    );
  }
}
