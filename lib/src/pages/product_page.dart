import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/Product.dart';
import 'package:formvalidation/src/providers/product_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductModel product;
  final ProductProvider _productProvider = new ProductProvider();
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context).settings.arguments ?? new ProductModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: (){}
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: (){}
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField( //Product field
                  initialValue: product.name,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Producto'
                  ),
                  validator: (value){
                    if(value.length < 3)
                      return 'Ingrese el nombre del producto';
                    else
                      return null;
                  },
                  onSaved: (value)=> product.name = value,
                ),
                TextFormField( //Price field
                  initialValue: product.price.toString(),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Precio'
                  ),
                  validator: (value){
                    if(!utils.isNumeric(value))
                      return 'Debe ser un valor númerico';
                    else
                      return null;
                  },
                  onSaved: (value)=> product.price = double.parse(value)
                ),
                SwitchListTile(
                  value: product.available,
                  onChanged: (value) => setState(() {
                    product.available = value;
                  }),
                  title: Text('Disponible'),
                ),
                RaisedButton.icon( //Save Button
                  onPressed: _isSaving ? null : _submit,
                  icon: Icon(Icons.save),
                  label: Text('Guardar'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async{
    bool isOk;
    String mensaje;
    if(formKey.currentState.validate()){
      //Cuando el form es válido
      formKey.currentState.save();
      setState(() {
        _isSaving = true;
      });
      if(product.id != null){
        isOk = await _productProvider.updateProduct(product.id, product);
        mensaje = isOk ? 'El producto se actualizó correctamente' : 'Hubo un problema al actualizar el producto';

      }else {
        isOk = await _productProvider.createProdcut(product);
        mensaje = isOk ? 'El producto se creó correctamente' : 'Hubo un problema al crear el producto';
      }
      setState(() {
        _isSaving = false;
      });
      showSnackbar(mensaje);
    }else{
      return;
    }
  }

  void showSnackbar(String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2000),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}