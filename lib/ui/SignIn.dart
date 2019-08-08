import 'dart:convert';

import 'package:employees_benefits/models/Employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../main.dart';
import 'HomePage.dart';
import 'MainApp.dart';
import 'SignUp.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Controllers
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  static Employee neededEmployee;


  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: MediaQuery.of(context).size.width / 7,
        child: Image.asset('assets/EvapharmaLogo.png'),
      ),
    );

    final email = TextField(
      keyboardType: TextInputType.emailAddress,
      controller: loginEmailController,
      autofocus: false,
      style: TextStyle(
          fontFamily: "WorkSansSemiBold", fontSize: 24.0, color: Color.fromRGBO(19, 46, 99, 10)),
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: loginPasswordController,
      style: TextStyle(
          fontFamily: "WorkSansSemiBold", fontSize: 24.0, color: Color.fromRGBO(19, 46, 99, 10)),
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: _onSignInButtonPress,
        padding: EdgeInsets.all(12),
        color: Color.fromRGBO(19, 46, 99, 10),
        child:
        Text('Log In', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Color.fromRGBO(19, 46, 99, 10), fontSize: 18),
      ),
      onPressed: (){},
    );

    final dontHaveAnAccount = FlatButton(
      child: Text(
        'Don\'t\ have an account',
        style: TextStyle(color: Color.fromRGBO(19, 46, 99, 10), fontSize: 18),
      ),
      onPressed: () =>
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()))
      },
    );


    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: MediaQuery.of(context).size.height / 25),
              email,
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              password,
              SizedBox(height: MediaQuery.of(context).size.height / 30),
              loginButton,
              forgotLabel,
              dontHaveAnAccount,
            ],
          ),
        ),

      ),
    );
  }

  void _onSignInButtonPress() async {
    final url = 'https://employees-benifits-app.firebaseio.com/employees.json';
    final httpClient = new Client();
    var response = await httpClient.get(url);

    Map employees = jsonCodec.decode(response.body);
    List<dynamic> emps = employees.values.toList();

    //TRIALS for debugging
    print(emps[0].employeeEmail + '\n' + emps[0].employeePassword);

    //Compare the entered email & pass with db
    for (int i = 0; i < emps.length; i++)
      if (emps[i].employeeEmail == loginEmailController.text &&
          emps[i].employeePassword == loginPasswordController.text) {
        mainEmployee = emps[i];
        mainEmployeeCompanyID = mainEmployee.employeeCompanyID.toString();
        Navigator.push
          (context,
            new MaterialPageRoute(builder:
                (context) => mainAPP));
      }
      else
        showInSnackBar('Incorrect email or password ! Please try again.');

    //TRIALS for debugging
    print(emps[0].employeeFirstName);
    print("Employees length: " + employees.length.toString());
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

}

_reviver(Object key, Object value) {
  if (key != null && value is Map) return new Employee.fromJson(value);
  return value;
}

const jsonCodec = const JsonCodec(reviver: _reviver);