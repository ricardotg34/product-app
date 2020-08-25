import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/Product.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  ProductModel product = new ProductModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  initialValue: product.title,
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
                  onSaved: (value)=> product.title = value,
                ),
                TextFormField( //Price field
                  initialValue: product.value.toString(),
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
                  onSaved: (value)=> product.value = double.parse(value)
                ),
                SwitchListTile(
                  value: product.available,
                  onChanged: (value) => setState(() {
                    product.available = value;
                  }),
                  title: Text('Disponible'),
                ),
                RaisedButton.icon( //Save Button
                  onPressed: _submit,
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

  void _submit(){
    if(formKey.currentState.validate()){
      //Cuando el form es válido
      formKey.currentState.save();
      print('Todo ok');
    }else{
      return;
    }
  }
}