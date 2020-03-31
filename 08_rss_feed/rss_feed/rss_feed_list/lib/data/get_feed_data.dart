import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'dart:io';

class GetFeedData {

  Future<List> read({String url}) async {
    //http.Client client = http.Client();
    //var data = await client.get(url);
    //xml.XmlDocument rss = xml.parse(response.body);
    List articles = [];
    try {
      var response = await http.get(url);
      //final rss = xml.parse(response.body);
      final rss = xml.parse(_returnResponseBody(response));

      rss.findAllElements('item')
        .forEach((node) {
          articles.add({
            'title': node.findElements('title').single.text,
            'link': node.findElements('link').single.text
          });
        });
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on ArgumentError {
      throw InvalidInputException('Bad URL');
    }
    return articles;
  }

  dynamic _returnResponseBody(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

}


class AppException implements Exception {
  final _message;
  final _prefix;
  
AppException([this._message, this._prefix]);
  
String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
