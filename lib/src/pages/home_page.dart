import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/products_bloc.dart';
import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/models/Product.dart';
import 'package:formvalidation/src/widgets/product_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsBloc _productsBloc;

  @override
  void didChangeDependencies() {
    _productsBloc = Provider.ofProducts(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _productsBloc.loadProducts();
    return Scaffold(
      appBar: AppBar(title: Text('Home page')),
      body: StreamBuilder(
        stream: _productsBloc.productsStream,
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if(snapshot.hasData){
            final products = snapshot.data;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => ProductTile(
                product: products[index],
                onDismissed: (direction){
                  setState(() {
                  });
                },
                onReturn: (){
                  Navigator.pushNamed(context, 'product', arguments: products[index]).then((value){
                    setState((){});
                  });
                }
              )
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'product').then((value){
          setState((){});
        }),
        child: Icon(Icons.add),
      ),
    );
  }
}