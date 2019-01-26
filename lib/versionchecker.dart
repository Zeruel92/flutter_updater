import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'APK.dart';
import 'dart:convert';
import 'package:package_info/package_info.dart';
import 'dart:core';

class VersionChecker {
  String appName;
  String packageName;
  String version;
  String buildNumber;
  String remoteVersion;
  String remoteBuildNumber;

  Future<void> getLastVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    try {
      Response vers = await http.get('http://192.168.1.215:8080/lastVersion');
      Map remoteMap = jsonDecode(vers.body);
      var remote = new APK.fromJSON(remoteMap);
      remoteVersion = remote.version;
      remoteBuildNumber = remote.buildNumber;
    } catch (e) {
      remoteBuildNumber = buildNumber;
      remoteVersion = version;
      print(e.toString());
    }
  }
}
