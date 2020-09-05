import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/Product.dart';
import 'package:formvalidation/src/providers/product_provider.dart';

class ProductTile extends StatelessWidget {
  final _provider = ProductProvider();
  final ProductModel product;
  final void Function(DismissDirection) onDismissed;
  final void Function() onReturn;
  ProductTile({this.product, this.onDismissed, this.onReturn});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: onDismissed,
      key: UniqueKey(),
      confirmDismiss: (direction) async{
        return await _provider.deleteProduct(product.id);
      },
      background: Container(
        color: Colors.red
      ),
      child: ListTile(
        leading: product.imagePath == null
        ? Image(image: AssetImage('assets/no-image.png'))
        : FadeInImage(
            placeholder: AssetImage('assets/jar-loading.gif'),
            image: NetworkImage('http://192.168.0.9:3000/products/images/${product.imagePath}')
          ),
        title: Text(product.name),
        trailing: Text('\$ ${product.price}'),
        subtitle: Text(product.available ? 'Disponible' : 'Agotado'),
        onTap: onReturn,
      ),
    );
  }
}