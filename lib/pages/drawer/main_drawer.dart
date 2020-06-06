import 'package:flutter/material.dart';
import 'package:firebaseapp/services/auth.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app,color: Colors.redAccent,),
              title: Text('Logout',style: TextStyle(fontSize: 18.0,color: Colors.redAccent),),
              onTap: () async{
                await _auth.signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}
