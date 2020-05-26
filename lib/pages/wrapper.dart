import 'package:firebaseapp/authenticate/authenticate.dart';
import 'package:firebaseapp/models/user.dart';
import 'package:firebaseapp/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    if(user==null)
      {
        return Authenticate();
      }
    else{
      return Home();
    }
  }
}
