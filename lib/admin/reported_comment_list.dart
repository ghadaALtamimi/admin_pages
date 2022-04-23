import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instayum_admin/admin/admin_home_page.dart';

import 'package:instayum_admin/admin/comment_obj.dart';
import 'package:instayum_admin/admin/user_information_design.dart';

class ReportedCommentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommentListState();
}

class CommentListState extends State<ReportedCommentList> {
  List<CommentObj> comments = [];

  List<CommentObj> ignoredComments = [];

  CollectionReference databaseRef;
  static String autherId;
  static String recipeId;
  @override
  Widget build(BuildContext context) {
    if (AdminHomePageState.inIgnored) {
      return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          children: [...ignoredComments.map(designComment).toList()]
              .reversed
              .toList());
    } else {
      return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(12),
          children: [
            ...comments.map(designComment).toList(),
          ].reversed.toList());
    }
  }

  getData() {
    // get data from database
    databaseRef = FirebaseFirestore.instance
        .collection("admin")
        .doc("reportes")
        .collection("ReportedComment");
    setState(() {});
    databaseRef.snapshots().listen((data) {
      comments.clear();
      ignoredComments.clear();
      data.docs.forEach((doc) {
        recipeId = doc["recipeId"];

        // add each comment doc in database to the list to show them in the screen
        print(doc["commentOwner"]);
        if (doc["Ignore"] == false) {
          comments.add(CommentObj(
            commentOwner: doc["commentOwner"],
            commentText: doc["commentText"],
            commentDate: doc["commentDate"],
            commentRef: doc["commentRef"],
            unethical: doc["unethical"],
            IDontLike: doc["IDontLike"],
            fraudulent: doc["fraudulent"],
            bullying: doc["bullying"],
            no_reports: doc["no_reports"],
            Ignore: false,
            reason: "",
          ));
        } else {
          ignoredComments.add(CommentObj(
            commentOwner: doc["commentOwner"],
            commentText: doc["commentText"],
            commentDate: doc["commentDate"],
            commentRef: doc["commentRef"],
            unethical: doc["unethical"],
            IDontLike: doc["IDontLike"],
            fraudulent: doc["fraudulent"],
            bullying: doc["bullying"],
            no_reports: doc["no_reports"],
            Ignore: false,
            reason: doc["reson"],
          ));
        }
      });
      if (this.mounted) {
        setState(() {
          comments;
          ignoredComments;
        });
      }
    });
  }

  void initState() {
    super.initState();
    getData();
  }

//******************************************************* */
  //---------------------------Delete a comment from firestore ------------------------------------------------**
  _DeletFirestoreComment(var key) async {
    print("-----------inside method_");
    print(key);
    await FirebaseFirestore.instance
        .collection("recipes")
        .doc(recipeId)
        .collection("comments")
        .doc(key)
        .delete();

    await FirebaseFirestore.instance
        .collection("admin")
        .doc("reportes")
        .collection("ReportedComment")
        .doc(key)
        .delete();
  }

  Widget IgnoreComment(var key, BuildContext context) {
    print("-----------inside method_");
    print(key);
//------------------------------

    String resone;

    return Column(
      children: [
        TextFormField(
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
                  color: Colors.orange,
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
                        .collection("ReportedComment")
                        .doc(key)
                        .update({
                      "Ignore": true,
                      "reson": resone,
                    });
//-----
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Comment ignored successfuly"),
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

  Widget repordelIcon(String commentRef) {
    final FirebaseAuth usId = FirebaseAuth.instance;
    final _currentUser = usId.currentUser.uid;

    return !AdminHomePageState.inIgnored
        ? Row(
            children: [
              IconButton(
                  onPressed: () {
                    _DeletFirestoreComment(commentRef);
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.red,
                  )),
              TextButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Text('write the reason of ignoring'),
                                SizedBox(
                                  height: 20,
                                ),
                                IgnoreComment(commentRef, context),
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
                  ))
            ],
          )
        : SizedBox();
  }

//********************************************************* */
//--------------------------------------------------------------------------
// ------------------- Design of each comment -----------------
  Widget designComment(CommentObj comment) => Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    comment.commentOwner,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("${comment.commentDate}",
                        style: TextStyle(color: Colors.grey))),
                //************************************ */
                SizedBox(
                  width: 10,
                ),

                InkWell(
                  onTap: () {
                    print("--------------------------");
                    print(comment.commentRef);
                    _DeletFirestoreComment(comment.commentRef);

                    AlertDialog(
                      title: Text("Are you sure to delete the comment ?"),
                      actions: [
                        Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(right: 20, left: 2),
                              padding: EdgeInsets.only(right: 12),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red,
                                  )),
                            ),

                            //Text('Delete'),
                          ],
                        ),
                      ],
                    );
                  },
                  child: repordelIcon(comment.commentRef),
                )
                //*************************************** */
              ],
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, top: 10),
                  child: Text(comment.commentText),
                )),
            Divider(
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 60,
              ),
              child: Row(
                children: [
                  Text("number of reports: " + "${comment.no_reports}"),
                  SizedBox(
                    width: 20,
                  ),
                  Text("bullying: " + " ${comment.bullying}"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
              ),
              child: Row(
                children: [
                  Text("fraudulent: " + "${comment.fraudulent}"),
                  SizedBox(
                    width: 20,
                  ),
                  Text("do not like: " + " ${comment.IDontLike}"),
                  SizedBox(
                    width: 20,
                  ),
                  Text("unethical: " + " ${comment.unethical}"),
                ],
              ),
            ),
            SizedBox(
              height: 20,
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
                      Text(comment.reason),
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
