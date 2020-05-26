import 'package:firebaseapp/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toogleView;
  SignIn({this.toogleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth= AuthService();
  final _formKey = GlobalKey<FormState>();

  var loading=false;
  loadingWidget(){
    if(loading)
      {
        return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator()
              ),
            ],
        );
      }
    else{
      return SizedBox.shrink();
    }
  }

  String email;
  String password;
  String error='';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title:Text('Sign In'),
          actions: <Widget>[
            FlatButton.icon(
              icon:Icon(Icons.person_add,color: Colors.white,),
              label: Text('Register',style: TextStyle(color:Colors.white),),
              onPressed: (){widget.toogleView();},
            )
          ]
      ),
      body:Container(
        padding:EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
        child: Form(
          key:_formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                child:Text('Sign in as Guest'),
                onPressed: () async{

                  setState(() {
                    loading=true;
                  });
                  dynamic result = await _auth.signInAnon();
                  if(result==null)
                  {
                    print('Error Signign');
                  }
                  else{
                    print(result.uid);
                  }
                },
              ),
              loadingWidget(),

              Divider(thickness: 3.0,),
              SizedBox(height: 30.0,),
              TextFormField(
                validator: (val)=> val.isEmpty ? 'Enter an email ':null,

                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.grey[100],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.black12,width: 1.0),
                  ),
                   focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:Colors.blueAccent,width: 1.0),
                  )

                ),
                onChanged: (val){
                  setState(()=>email=val);
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                validator: (val)=> val.length < 6  ? 'Enter password 6 characters long':null,
                decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: Colors.grey[100],
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.black12,width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:Colors.blueAccent,width: 1.0),
                    )

                ),
                onChanged: (val){
                  setState(()=>password=val);
                },
                obscureText: true,
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading=true;
                    });
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result==null){
                      setState(() {
                        loading=false;
                        error='Could not Sign In, Please Check Email and Password';
                      });

                    }
                  }
                },
                color:Colors.green,
                child:Text('Sign in',style:TextStyle(color:Colors.white)),

              )
            ] ,
          ),
        ),
      )
    );
  }
}
