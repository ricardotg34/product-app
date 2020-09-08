import 'dart:convert';

import 'package:http/http.dart';

class ResponseModel {
  bool success;
  dynamic body;
  int statusCode;
  String message;

  ResponseModel({
    this.message = '',
    this.success = true,
    this.body = const {},
    this.statusCode = 200,
  });

  ResponseModel.fromResponse(Response res){
    try {
      body = json.decode(res.body);
    } catch(error) {
      body = const {};
    } finally {
      message = res.reasonPhrase;
      statusCode = res.statusCode;
      success = res.statusCode >= 200 && res.statusCode <= 210;
    }
  }
}
