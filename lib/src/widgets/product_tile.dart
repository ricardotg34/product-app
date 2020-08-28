import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/Product.dart';
import 'package:formvalidation/src/providers/product_provider.dart';

class ProductTile extends StatelessWidget {
  final _provider = ProductProvider();
  final ProductModel product;
  ProductTile({this.product});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) async{
        return await _provider.deleteProduct(product.id);
      },
      background: Container(
        color: Colors.red
      ),
      child: ListTile(
        title: Text(product.name),
        trailing: Text('\$ ${product.price}'),
        subtitle: Text(product.available ? 'Disponible' : 'Agotado'),
        onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
      ),
    );
  }
}