import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/products_bloc.dart';
import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/models/Product.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;
  final void Function(DismissDirection) onDismissed;
  final void Function() onReturn;
  ProductTile({this.product, this.onDismissed, this.onReturn});
  @override
  Widget build(BuildContext context) {
    ProductsBloc _productsBloc = Provider.ofProducts(context);
    return Dismissible(
      onDismissed: onDismissed,
      key: UniqueKey(),
      confirmDismiss: (direction) async{
        return await _productsBloc.deleteProduct(product.id);
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