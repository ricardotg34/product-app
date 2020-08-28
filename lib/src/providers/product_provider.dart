import 'dart:convert';

import 'package:formvalidation/src/models/Product.dart';
import 'package:http/http.dart' as http;

class ProductProvider {
  final String _url = '192.168.0.9:3000';

  Future<bool> createProdcut(ProductModel product) async{
    final url = Uri.http(_url, '/products');
    final body = jsonEncode({
      "name": product.name,
      "price": product.price,
      "available": product.available
    });
    final headers = {
      "Content-Type": "application/json"
    };
    final res = await http.post(url, headers: headers, body: productoModelToJson(product));
    return res.statusCode == 201;
  }

  Future<List<ProductModel>> loadProducts() async {
    final url = Uri.http(_url, '/products');
    final res = await http.get(url);
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
    final headers = {
      "Content-Type": "application/json"
    };
    final res = await http.put(url, headers: headers, body: productoModelToJson(product));
    return res.statusCode == 200;
  }

  Future<bool> deleteProduct(String id) async {
    final url = Uri.http(_url, '/products/$id');
    final res = await http.delete(url);
    return res.statusCode == 204;
  }
}