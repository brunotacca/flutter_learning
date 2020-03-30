import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class SaveLocal {
  final List feedList;
  SaveLocal({this.feedList});

  get fileFeed async {
    Directory dir = await getApplicationSupportDirectory();
    File file = File(dir.path + "/feeds.json");
    if(!file.existsSync()) {
      save(feedList);
    }

    return file;
  }

  read() async {
    final File file = await fileFeed;
    String data = file.readAsStringSync();
    return json.decode(data);
  }

  save(data) async {
    final File file = await fileFeed;
    file.writeAsStringSync(json.encode(data));
  }
}