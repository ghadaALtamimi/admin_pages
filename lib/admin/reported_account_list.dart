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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController reasonTextFieldController = TextEditingController();
  List<ReprtedAccount> _accounts = [];
  List<ReprtedAccount> _ignoredAccounts = [];
  CollectionReference _databaseRef;

  @override
  Widget build(BuildContext context) {
    if (AdminHomePageState.inIgnored) {
      return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          children: [..._ignoredAccounts.map(designAccountList).toList()]
              .reversed
              .toList());
    } else {
      return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          children: [
            ..._accounts.map(designAccountList).toList(),
          ].reversed.toList());
    }
  }

  getData() {
    // get data from database
    _databaseRef = FirebaseFirestore.instance
        .collection("admin")
        .doc("reportes")
        .collection("ReportedAcount");
    setState(() {});
    _databaseRef.snapshots().listen((data) {
      _accounts.clear();
      _ignoredAccounts.clear();

      data.docs.forEach((doc) {
        // add each account doc in database to the list to show them in the screen

        if (doc["Ignore"] == false) {
          _accounts.add(ReprtedAccount(
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
          _ignoredAccounts.add(ReprtedAccount(
            username: doc["username"],
            userId: doc["userId"],
            unethical: doc["unethical"],
            IDontLike: doc["IDontLike"],
            fraudulent: doc["fraudulent"],
            bullying: doc["bullying"],
            no_reports: doc["no_reports"],
            Ignore: true,
            reason: doc["reason"],
          ));
        }
      });
      if (this.mounted) {
        setState(() {
          _accounts;
          _ignoredAccounts;
        });
      }
    });
  }

  Widget IgnoreAccount(var key, BuildContext context) {
    String reasone;
    return AlertDialog(
      //backgroundColor: Theme.of(context).backgroundColor,
      title: Center(
        child: Text(
          "Write the reason of ignored",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
      ),
//--------------------------------------
      content: new SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                key: ValueKey("reasone"),
                controller: reasonTextFieldController,
                decoration: InputDecoration(
                    // errorText:
                    //     _isEmptyCookbookTitle ? 'title can not be empty' : null,
                    ),
                validator: (value) {
                  if (value == null || value == '' || value.isEmpty)
                    return 'Reason can not be empty ';
                  else
                    return null;
                },
                onChanged: (value) {
                  reasone = value;
                },
              ),
            ),
          ],
        ),
      ),

      actions: [
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
              onPressed: () async {
                reasonTextFieldController.clear();
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
                  reasone = reasonTextFieldController
                      .text; // check if the ingredient is already exist do not add it to the shooping
                  if (!formKey.currentState.validate()) {
                    print(formKey.currentState.validate());
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
                      "reason": reasone,
                    });
                    print("apdated");

//-----
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Reported ignored successfuly"),
                          backgroundColor: Colors.green),
                    );
                    reasonTextFieldController.clear();
                  }
                }),
            // ]);
          ],
        )
      ],
    );
  }

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
                                      return IgnoreAccount(
                                          account.userId, context);
                                      // AlertDialog(
                                      //   title: Column(
                                      //     children: [
                                      //       Text(
                                      //           'write the reason of ignoring'),
                                      //       SizedBox(
                                      //         height: 20,
                                      //       ),
                                      //       IgnoreAccount(
                                      //           account.userId, context),
                                      //       SizedBox(
                                      //         height: 20,
                                      //       ),
                                      //     ],
                                      //   ),
                                      // );
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
