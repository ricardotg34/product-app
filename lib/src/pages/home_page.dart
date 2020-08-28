import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/Product.dart';
import 'package:formvalidation/src/providers/product_provider.dart';
import 'package:formvalidation/src/widgets/product_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _provider = ProductProvider();
    return Scaffold(
      appBar: AppBar(title: Text('Home page')),
      body: FutureBuilder(
        future: _provider.loadProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if(snapshot.hasData)
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) => ProductTile(
                product: snapshot.data[index]
              )
            );
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