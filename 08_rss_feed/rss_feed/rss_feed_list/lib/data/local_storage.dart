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

}