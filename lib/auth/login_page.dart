import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tamwink/admin/admin_home.dart';
import 'package:tamwink/customer/maincustomer.dart';

class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  String _email ,  _password ;
  bool isTrader=false;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;


  @override
  void initState() {
    super.initState();
    emailInputController= TextEditingController();
    pwdInputController= TextEditingController();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: Form(
          key: _loginFormKey,
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [
                        Colors.orange[900],
                        Colors.orange[800],
                        Colors.orange[400]
                      ]
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100,),
                  Padding(
                    ////////////////////////////////////////////
                    padding:EdgeInsets.all(20),
                    //  EdgeInsets.symmetric(vertical:18.0,horizontal: 280.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("تموينك", style: TextStyle(color: Colors.white, fontSize: 40,),),
                        SizedBox(height: 24,),
                        Text("مرحبا بكم", style: TextStyle(color: Colors.white, fontSize: 18,),),

                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 60,),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10)
                                    )]
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                      ),
                                      child: TextFormField(
                                        // ignore: missing_return
                                        validator: emailValidator,
                                        controller: emailInputController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            hintText: "البريد الالكتروني",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                            icon: Icon(Icons.email)
                                        ),
                                        onSaved: (input) => _email = input,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                      ),
                                      child: TextFormField(
                                        // ignore: missing_return
                                        validator:pwdValidator,
                                        controller: pwdInputController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: " كلمة المرور",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                            icon: Icon(Icons.vpn_key)
                                        ),
                                        onSaved: (input) => _password = input,
                                        obscureText: true,
                                      ),
                                    ),
//                                  new Checkbox(value: _value1, onChanged: _value1Changed),
                                    new CheckboxListTile(
                                      value: isTrader,
                                      onChanged:  (value) {
                                        setState(() {
                                          isTrader = value;
                                        });
                                      },
                                      title: new Text('أدخل كتاجر'),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      activeColor: Colors.deepOrange,
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 15.0,),
                              Container(

                                child: MaterialButton(
                                  onPressed :(){
                                    Navigator.pushNamed(context,'/password_page');

                                  },
                                  child: Center(
                                    child: Text("نسيت كلمة المرور؟", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0,),
                              Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orange[900]
                                ),

                                child: GestureDetector(
                                  onDoubleTap :(){},

                                  child: Center(
                                    child: FlatButton(
                                      onPressed: signIn,

                                      child:
                                      Text("تسجيل الدخول", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),


                                      ),


                                    ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0,),
////////////////////////////////////////////////////////////////////////////////////////////////////////
                              Container(
                                child: MaterialButton(
                                  onPressed :(){
                                    Navigator.pushNamed(context,'/register');

                                  },
                                  child: Center(
                                    child: Text("التسجيل كمستخدم جديد", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),
                              ////////////////////////////////////////////////////////////////////////////////////
                              SizedBox(height: 15.0,),


                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        ),

    );

  }

  void signIn()async{
    if (_loginFormKey.currentState.validate()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailInputController.text,
          password: pwdInputController.text)
          .then((currentUser) => Firestore.instance
          .collection("users")
          .document(currentUser.user.uid)
          .get()
          .then((DocumentSnapshot result){
          bool userType = (result.data)['isTrader'];
          if (userType == false && isTrader == false)
      {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage()));
      }
          else if(userType == true && isTrader == true) {
            print("Trader Page");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Admin()));

          }
          else{
            print("cannot login because isTrader $isTrader");
          }
      }
          )
          .catchError((err) => print(err)))
          .catchError((err) => print(err));
    }

  }
String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  } else {
    return null;
  }
}

String pwdValidator(String value) {
  if (value.length < 8) {
    return 'Password must be longer than 8 characters';
  } else {
    return null;
  }
}

}
