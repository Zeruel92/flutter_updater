class APK {

    String appName;
    String packageName;
    String version;
    String buildNumber;
    //String path;

    APK({this.appName,this.packageName,this.version,this.buildNumber});

    APK.fromJSON(Map<String, dynamic> json)
      : appName = json['name'],
        version = json['version'],
        //path = json['path'],
        packageName = json['packageName'],
        buildNumber = json['buildNumber'];
    
}
