import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class LocalStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/feeds.json');
  }

  readFileFeeds() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeFeeds(data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(json.encode(data));
  }


  /*
  Future<File> get fileFeed async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File(dir.path + "/feeds.json");
    if (!file.existsSync()) {
      await save(feedList);
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

    return file.writeAsString(json.encode(data));
  }
  */
}