import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum_admin/admin/reported_account.dart';

import 'package:instayum_admin/admin/user_information_design.dart';

class ReportedAccountList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ReportedAccountListState();
}

class ReportedAccountListState extends State<ReportedAccountList> {
  List<ReprtedAccount> accounts = [];
  CollectionReference databaseRef;
  static String autherId;
  static String recipeId;
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(12),
        children: [
          ...accounts.map(designAccountList).toList(),
        ].reversed.toList());
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

      data.docs.forEach((doc) {
        // add each account doc in database to the list to show them in the screen

        accounts.add(ReprtedAccount(
          username: doc["username"],
          userId: doc["username"],
          unethical: doc["unethical"],
          IDontLike: doc["IDontLike"],
          fraudulent: doc["fraudulent"],
          bullying: doc["bullying"],
          no_reports: doc["no_reports"],
        ));
      });
      if (this.mounted) {
        setState(() {
          accounts;
        });
      }
    });
  }

  void initState() {
    super.initState();
    getData();
  }

//******************************************************* */
  //---------------------------Delete a account from firestore ------------------------------------------------**
  // _DeletFirestoreComment(var key) async {
  //   print("-----------inside method_");
  //   print(key);
  //   await FirebaseFirestore.instance
  //       .collection("recipes")
  //       .doc(recipeId)
  //       .collection("comments")
  //       .doc(key)
  //       .delete();

  //   await FirebaseFirestore.instance
  //       .collection("admin")
  //       .doc("reportes")
  //       .collection("ReportedComment")
  //       .doc(key)
  //       .delete();
  // }
  //--------------------

  // Widget repordelIcon(String commentRef) {
  //   final FirebaseAuth usId = FirebaseAuth.instance;
  //   final _currentUser = usId.currentUser.uid;

  //   return IconButton(
  //       onPressed: () {
  //         _DeletFirestoreComment(commentRef);
  //       },
  //       icon: Icon(
  //         Icons.delete_outline,
  //         size: 20,
  //         color: Colors.red,
  //       ));
  // }

//********************************************************* */
//--------------------------------------------------------------------------
// ------------------- Design of each reported account -----------------
  Widget designAccountList(ReprtedAccount account) => Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Text(
                    account.username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  "Number of reports: " + "${account.no_reports}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),

                //************************************ */

                //*************************************** */
              ],
            ),
            Divider(
              height: 20,
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 90,
              ),
              child: Row(
                children: [
                  Text("Bullying: " + " ${account.bullying}"),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Fraudulent: " + "${account.fraudulent}"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 90,
              ),
              child: Row(
                children: [
                  Text("Do not like: " + " ${account.IDontLike}"),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Unethical: " + " ${account.unethical}"),
                ],
              ),
            ),
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
