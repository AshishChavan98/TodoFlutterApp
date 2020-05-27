import 'package:firebaseapp/authenticate/register.dart';
import 'package:firebaseapp/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {


  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool signIn = true;




  @override
  Widget build(BuildContext context) {
    Function toggleView(){

      setState(() {
        signIn=!signIn;
      });
    }

    if(signIn) {
      return SignIn(toogleView: toggleView);
    }
    else{
      return Register(toogleView:toggleView);
    }
  }
}
