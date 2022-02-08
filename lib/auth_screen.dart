import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:instayum1/main_pages.dart';
// import 'package:instayum1/widget/admin/admin_home_page.dart';
// import 'package:instayum1/widget/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instayum_admin/admin/admin_home_page.dart';
import 'package:instayum_admin/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  static bool isAdmin = false;
  void _submitAuthForm(
    String email,
    String password,
    BuildContext ctx,
    // we recevice the context of form Scafflod to have the ability to push the snakcbar messages and to use theme color.
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      //log in
      authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //here we can check the admin
      // if (email == 'admin@admin.admin') {
      //   setState(() {
      //     isAdmin = true;
      //   });
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //       builder: (context) => AdminHomePage(),
      //     ),
      //   );
      // } else {
      // to move the user to the profile page (Mainpages) after he login successfully
      setState(() {
        isAdmin = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AdminHomePage(),
        ),
      );
      // }
      // }
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      print('catch #1');
      // print(err);
      //to handel the error of firebase in case of entring non-valid email or password
      var message = "There is an error, please check your credentials!";

      if (err.message != null) {
        message = err.message.toString();
        message = "error ";
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
            content: Text(message), backgroundColor: Theme.of(ctx).errorColor),
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });

      print('catch #2');
      print(error.code);
      switch (error.code) {
        case 'wrong-password':
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email or password is incorrect try again!"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
          break;
        case 'user-not-found':
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email or password is incorrect try again!"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
          break;
        case 'email-already-in-use':
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email address is taken"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
          break;
        default:
          // print(err.code);
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
                content: Text("The email or password is invalid try again!"),
                backgroundColor: Theme.of(ctx).errorColor),
          );
      }
    } catch (error) {
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          _isLoading = false;
        });
      }
      if (!(error is FirebaseAuthException)) {
        print('message in catch3:');
        print(error.message); // this is the actual error that you are getting
      }
      print('catch #3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
