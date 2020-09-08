import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:formvalidation/src/models/response_model.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final dotenv = DotEnv();
  Future<ResponseModel> newUser(String email, String password) async{
    final url = Uri.http(dotenv.env['API_URL'], '${dotenv.env['AUTH_ENDPOINT']}signUp');
    final body = {
      "email": email,
      "password": password
    };
    final res = await http.post(url, body: body);
    return ResponseModel.fromResponse(res);
  }

  Future<ResponseModel> login(String email, String password) async{
    final url = Uri.http(dotenv.env['API_URL'], '${dotenv.env['AUTH_ENDPOINT']}signIn');
    final body = {
      "email": email,
      "password": password
    };
    final res = await http.post(url, body: body);
    return ResponseModel.fromResponse(res);
  }
}