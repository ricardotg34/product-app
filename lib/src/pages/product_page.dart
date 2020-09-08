import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/products_bloc.dart';
import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/models/Product.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductsBloc _productsBloc;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductModel product;
  bool _isSaving = false;
  File photo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product = ModalRoute.of(context).settings.arguments ?? new ProductModel();
    _productsBloc = Provider.ofProducts(context);
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
            onPressed:() => _selectPhoto(ImageSource.gallery)
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _selectPhoto(ImageSource.camera)
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
                _productImage(),
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

  Widget _productImage(){
    if( product.imagePath != null){
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage('http://192.168.0.9:3000/products/images/${product.imagePath}'),
        fit: BoxFit.cover,
        height: 300,
      );
    } else {
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300,
        fit: BoxFit.cover
      );
    }
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
        isOk = await _productsBloc.updateProduct(product.id, product);
        mensaje = isOk ? 'El producto se actualizó correctamente' : 'Hubo un problema al actualizar el producto';
        if(photo != null) _productsBloc.uploadImage(photo, product.id);
      }else {
        final response = await _productsBloc.createProduct(product);
        mensaje = response['isOk'] ? 'El producto se creó correctamente' : 'Hubo un problema al crear el producto';
        if(photo != null) _productsBloc.uploadImage(photo, response['product'].id);
        setState(() {
          photo = null;
          product.available = true;
          product.name = '';
          product.price = 0.0;
        });
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

  void _selectPhoto(ImageSource origin) async{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: origin);
    photo = File(pickedFile.path);
    print(photo.path);
    if (photo != null) {
      product.imagePath = null;
    }
    setState(() {});
  }
}