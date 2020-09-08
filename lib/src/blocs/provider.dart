import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/login_bloc.dart';
import 'package:formvalidation/src/blocs/products_bloc.dart';

class Provider extends InheritedWidget{
  final loginBloc = LoginBloc();
  final producsBloc = ProductsBloc();


  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc ofLogin(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

    static ProductsBloc ofProducts(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().producsBloc;
  }
}