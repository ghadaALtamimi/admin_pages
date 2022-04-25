import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum_admin/admin/admin_home_page.dart';
import 'package:instayum_admin/admin/reported_account.dart';

import 'package:instayum_admin/admin/user_information_design.dart';

class ReportedAccountList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportedAccountListState();
}

class ReportedAccountListState extends State<ReportedAccountList> {
  List<ReprtedAccount> accounts = [];
  List<ReprtedAccount> ignoredAccounts = [];
  CollectionReference databaseRef;
  static String autherId;
  static String recipeId;
  @override
  Widget build(BuildContext context) {
    if (AdminHomePageState.inIgnored) {
      return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          children: [...ignoredAccounts.map(designAccountList).toList()]
              .reversed
              .toList());
    } else {
      return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          children: [
            ...accounts.map(designAccountList).toList(),
          ].reversed.toList());
    }
  }

  getData() {
    // get data from database
    databaseRef = FirebaseFirestore.instance
        .collection("admin")
        .doc("reportes")
        .collection("ReportedAcount");
    setState(() {});
    databaseRef.snapshots().listen((data) {
      accounts.clear();
      ignoredAccounts.clear();

      data.docs.forEach((doc) {
        // add each account doc in database to the list to show them in the screen

        if (doc["Ignore"] == false) {
          accounts.add(ReprtedAccount(
            username: doc["username"],
            userId: doc["userId"],
            unethical: doc["unethical"],
            IDontLike: doc["IDontLike"],
            fraudulent: doc["fraudulent"],
            bullying: doc["bullying"],
            no_reports: doc["no_reports"],
            Ignore: false,
            reason: "",
          ));
        } else {
          ignoredAccounts.add(ReprtedAccount(
            username: doc["username"],
            userId: doc["userId"],
            unethical: doc["unethical"],
            IDontLike: doc["IDontLike"],
            fraudulent: doc["fraudulent"],
            bullying: doc["bullying"],
            no_reports: doc["no_reports"],
            Ignore: true,
            reason: doc["reson"],
          ));
        }
      });
      if (this.mounted) {
        setState(() {
          accounts;
          ignoredAccounts;
        });
      }
    });
  }

  Widget IgnoreAccount(var key, BuildContext context) {
    print("-----------inside method_");
    print(key);
//------------------------------

    String resone;
    TextEditingController textController;
    return Column(
      children: [
        TextFormField(
          controller: textController,
          onChanged: (value) {
            resone = value;
          },
        ),
        //--------------------------add or cancel
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(color: Theme.of(context).accentColor, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xFFeb6d44),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 5,
            ),
            RaisedButton(
                child: Text(
                  "Ignore",
                ),
                onPressed: () {
                  // check if the ingredient is already exist do not add it to the shooping
                  if (resone == null) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("you did not write reason to ignore"),
                          backgroundColor: Theme.of(context).errorColor),
                    );
                  } else {
                    // -------- Add the ingredant to the shoping list------------

                    // ------ Update ---------------
                    FirebaseFirestore.instance
                        .collection("admin")
                        .doc("reportes")
                        .collection("ReportedAcount")
                        .doc(key)
                        .update({
                      "Ignore": true,
                      "reson": resone,
                    });
                    print("apdated");

//-----
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Reported ignored successfuly"),
                          backgroundColor: Colors.green),
                    );
                  }
                }),
            // ]);
          ],
        )
      ],
    );

//------------------------------
  }

  // Widget IgnorIcon(String accountRef) {
  //   final FirebaseAuth usId = FirebaseAuth.instance;
  //   final _currentUser = usId.currentUser.uid;

  //   return
  // }

  void initState() {
    super.initState();
    getData();
  }

//******************************************************* */
  //***************************************** */
//--------------------------------------------------------------------------
// ------------------- Design of each reported account -----------------
  Widget designAccountList(ReprtedAccount account) => Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    account.username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Spacer(),
                !AdminHomePageState.inIgnored
                    ? Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Text(
                                                'write the reason of ignoring'),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            IgnoreAccount(
                                                account.userId, context),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Text(
                                "Ignore",
                                style: TextStyle(
                                  color: Color(0xFFeb6d44),
                                  fontSize: 14,
                                ),
                              )),
                        ],
                      )
                    : SizedBox(),
                //************************************ */
                //IgnorIcon(account.userId)
                //*************************************** */
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [],
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Number of reports: " + "${account.no_reports}",
                ),
                Text("Bullying: " + " ${account.bullying}"),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Do not like: " + " ${account.IDontLike}"),
                Text("Unethical: " + " ${account.unethical}"),
                Text("Fraudulent: " + "${account.fraudulent}"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            AdminHomePageState.inIgnored
                ? Row(
                    children: [
                      Text(
                        "Reason: ",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(account.reason),
                    ],
                  )
                : SizedBox(),
            Divider(
              color: Colors.black38,
              height: 20,
              thickness: 4,
              indent: 5,
              endIndent: 5,
            ),
          ],
        ),
      );
}
