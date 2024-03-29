//import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:instayum1/widget/auth/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instayum_admin/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoeading,
  );

  final void Function(
    String email,
    String password,
    BuildContext ctx,
  ) submitFn;
  final bool isLoeading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  //final TextEditingController _confirmPass = TextEditingController();

  //bool _isSignUp = true;

  var _userEmail = "";
  // var _userName = "";
  var _userPassword = "";
  // File _userImageFile;

  // void _pickedImage(File image) {
  //   _userImageFile = image;
  // }

  void _trySubmit() async {
    _formKey.currentState
        .save(); //To save the data we took from the user in form in OnSaved method.

    final isValidFormt =
        _formKey.currentState.validate(); // to check the Validitor in the form.
    FocusScope.of(context).unfocus();

    if (isValidFormt) {
      //print('in checking if ____________________');

      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(), // trim here to delete any extar space at the end

        _userPassword.trim(),

        context,
      );
    }
  }

  bool _isValidEmail(String email) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(email);
  }

  bool _isValiedPassword(String password) {
    //if in signup check the password

    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';

    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(password);

    // return true when in login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).accentColor),
                    ),
                    // if (_isSignUp) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey(
                          "email"), // علشان اذا حولت من لوق ان الى ساين اب ما يتحول الوزرنيم الى باسوورد
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email should not be empty";
                        } else if (!_isValidEmail(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Email address"),
                    ),

                    TextFormField(
                      controller: _pass,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "password should not be empty";
                        } else if (!_isValiedPassword(value)) {
                          return "The password must conatint at least \none upper case \none lower case \none digit \nand at least 6 characters in length";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true, // to hide the password
                    ),

                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoeading) CircularProgressIndicator(),
                    if (!widget.isLoeading)
                      RaisedButton(
                        child: Text("Login"),
                        onPressed: _trySubmit,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
