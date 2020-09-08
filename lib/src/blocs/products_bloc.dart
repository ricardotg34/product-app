import 'dart:io';

import 'package:formvalidation/src/providers/product_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:formvalidation/src/models/Product.dart';

class ProductsBloc {
  final _productsController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  void loadProducts() async {
    final products = await _productsProvider.loadProducts();
    _productsController.sink.add(products);
  }

  Future<Map<String, dynamic>> createProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    final res = await _productsProvider.createProduct(product);
    _loadingController.sink.add(false);
    return {
      "isOk": res.success,
      "product": ProductModel.fromJson(res.body)
    };
  }

  void uploadImage(File image, String id) async {
    _loadingController.sink.add(true);
    await _productsProvider.uploadImage(image, id);
    _loadingController.sink.add(false);
  }

  Future<bool> updateProduct(String id, ProductModel product) async {
    _loadingController.sink.add(true);
    final res = await _productsProvider.updateProduct(id, product);
    _loadingController.sink.add(false);
    return res.success;
  }

  Future<bool> deleteProduct(String id) async {
    _loadingController.sink.add(true);
    final isOk = await _productsProvider.deleteProduct(id);
    _loadingController.sink.add(false);
    return isOk;
  }

  dispose() {
    _productsController?.close();
    _loadingController?.close();
  }
}
