import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/login_bloc.dart';
import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/providers/user_provider.dart';

class RegisterPage extends StatelessWidget {
  final _userProvider = UserProvider();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          _loginBackground(context),
          _loginForm(context),
        ],
      )
    );
  }

  Widget _loginBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondo = Container(
      height: size.height * 0.4,
      width:  double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(100, 42, 63, 1.0),
            Color.fromRGBO(158, 60, 96, 1.0)
          ])
      ),
    );

    final circulo = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: [
        fondo,
        Positioned(top: 90, left: -30,child: circulo),
        Positioned(top: -40, right: -30,child: circulo),
        Positioned(top: 140, right: -30,child: circulo),
        Positioned(bottom: -20, right: 150,child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100),
              SizedBox(height: 10, width: double.infinity),
              Text('Ricardo TG', style: TextStyle(color: Colors.white, fontSize: 25))
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.ofLogin(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: 180)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30.0),
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0, 5),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: [
                Text('Crear cuenta', style: TextStyle(fontSize: 20)),
                _emailField(bloc),
                _passwordField(bloc),
                SizedBox(height: 20,),
                _button(bloc)
              ],
            ),
          ),
          FlatButton(child: Text('¿Ya tienes cuenta?'), onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'))
        ],
      ),
    );
  }

  Widget _emailField(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        return ListTile(
          title: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      }
    );
  }

  Widget _passwordField(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        return ListTile(
          title: TextField(
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
              labelText: 'Contraseña',
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      }
    );
  }

  Widget _button(LoginBloc bloc) {
    return StreamBuilder<Object>(
      stream: bloc.formValidStream,
      builder: (context, snapshot) {
        return ListTile(
          title: RaisedButton(
            onPressed: snapshot.hasData ? ()=> _register(bloc, context) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            elevation: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              child: Text('Ingresar', style: Theme.of(context).textTheme.button),
            ),
          ),
        );
      }
    );
  }

  _register(LoginBloc bloc, BuildContext context) async {
    final res = await _userProvider.newUser(bloc.email, bloc.password);
    print('Email: ${bloc.email}');
    print('Password: ${bloc.password}');
    if(res.success){
      Navigator.of(context).pushReplacementNamed('login');
    } else {
      showSnackbar('No se pudo guardar el usuario');
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