import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart' as asyn;

import 'package:formvalidation/src/models/Product.dart';
import 'package:formvalidation/src/utils/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ProductProvider {
  final String _url = '192.168.0.9:3000';
  final _headers = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: 'Bearer ${UserPreferences().token}'
  };

  Future<Map<String, dynamic>> createProdcut(ProductModel product) async{
    final url = Uri.http(_url, '/products');
    final res = await http.post(url, headers: _headers, body: productoModelToJson(product));
    final resData = json.decode(res.body);
    return {
      "isOk": res.statusCode == 201,
      "product": ProductModel.fromJson(resData)
    };
  }

  Future<List<ProductModel>> loadProducts() async {
    final url = Uri.http(_url, '/products');
    final res = await http.get(url, headers: _headers);
    List<ProductModel> productList = new List();
    final decodedData = json.decode(res.body);
    for (var data in decodedData) {
      final product = ProductModel.fromJson(data);
      productList.add(product);
    }
    return productList;
  }

  Future<bool> updateProduct(String id, ProductModel product) async {
    final url = Uri.http(_url, '/products/$id');
    final res = await http.put(url, headers: _headers, body: productoModelToJson(product));
    return res.statusCode == 200;
  }

  Future<bool> deleteProduct(String id) async {
    final url = Uri.http(_url, '/products/$id');
    final res = await http.delete(url, headers: _headers);
    return res.statusCode == 204;
  }

  Future<String> uploadImage(File imageFile, String id) async {
    //Saves content image in a byte stream
    var stream = new http.ByteStream(asyn.DelegatingStream(imageFile.openRead()));
    var length = await imageFile.length();
    final url = Uri.http(_url,'/products/setImage/$id');
    final Object headers = {
      "Accept": "application/json"
    };
    var request = new http.MultipartRequest("POST", url);
    var multipartFile = new http.MultipartFile('file', stream, length,filename: path.basename(imageFile.path));
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    var response = await request.send().timeout(Duration(seconds: 10));
    var value = await response.stream.bytesToString();
    print(value);
    return null;
  }
}