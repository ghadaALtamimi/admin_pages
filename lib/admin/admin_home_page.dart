import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instayum_admin/admin/reported_account_list.dart';

import 'package:instayum_admin/admin/reported_comment_list.dart';
import 'package:instayum_admin/auth_screen.dart';

class AdminHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  static bool inIgnored = false;
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget noButton = RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).accentColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "No",
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = RaisedButton(
      child: Text(
        "Yes",
      ),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pop();
        print('sign out^^^^^^^^^^^^^^^^^^^^^^^^^^');
        print('Before moving the user to the sign up page ***********');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //backgroundColor: Theme.of(context).backgroundColor,
      title: Center(
          child: Text(
        "Logout",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
      )),
      content: Text(
        "Are you sure you want to logout of the account? ",
        style: TextStyle(color: Color(0xFF444444)),
      ),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home Page"),
        backgroundColor: Color(0xFFeb6d44),
        leading: Container(child: Image.asset("assets/images/logo.png")),
        actions: [
          //-------------------------------
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ccontext) => Scaffold(
                        appBar: AppBar(
                            title: Text("Ignored reported"),
                            backgroundColor: Color(0xFFeb6d44),
                            leading: IconButton(
                              onPressed: () {
                                inIgnored = false;

                                Navigator.pop(context);
                                // setState(() {});
                              },
                              icon: Icon(Icons.arrow_back),
                            )),
                        body: ignoredReports(),
                      ),
                    ));
              },
              icon: Icon(Icons.warning)),
          //---------------------------------------
          IconButton(
              onPressed: () {
                showAlertDialog(context);
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).primaryIconTheme.color,
              )),
        ],
      ),
      body: DefaultTabController(
        length: 2,

        // allows you to build a list of elements that would be scrolled away till the body reached the top

        // You tab view goes here and its bar view
        child: Column(
          children: <Widget>[
            //
            TabBar(
              labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              labelColor: Color(0xFFeb6d44),
              indicatorColor: Color(0xFFeb6d44),
              tabs: [
                Tab(
                    icon: Icon(Icons.comment),
                    text: ("List Of Reprted Comment")),
                Tab(
                    icon: Icon(Icons.account_box),
                    text: ("List Of Reported Account")),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  //This list is the content of each tab.
                  // ------------ reported comment-------------
                  ReportedCommentList(),

                  // ------------ reported account-----------.
                  ReportedAccountList(),

                  // bookmarked_recipes(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DefaultTabController ignoredReports() {
    inIgnored = true;
    return DefaultTabController(
      length: 2,
      // allows you to build a list of elements that would be scrolled away till the body reached the top

      // You tab view goes here and its bar view
      child: Column(
        children: <Widget>[
          //
          TabBar(
            labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            labelColor: Color(0xFFeb6d44),
            indicatorColor: Color(0xFFeb6d44),
            tabs: [
              Tab(icon: Icon(Icons.comment), text: ("Ignored Reprted Comment")),
              Tab(
                  icon: Icon(Icons.account_box),
                  text: ("Ignored Reported Account")),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                //This list is the content of each tab.
                // ------------ reported comment-------------
                ReportedCommentList(),

                // ------------ reported account-----------.
                ReportedAccountList(),

                // bookmarked_recipes(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
