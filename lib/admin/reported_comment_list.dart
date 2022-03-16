import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:instayum_admin/admin/comment_obj.dart';
import 'package:instayum_admin/admin/user_information_design.dart';

class ReportedCommentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommentListState();
}

class CommentListState extends State<ReportedCommentList> {
  List<CommentObj> comments = [];
  CollectionReference databaseRef;
  static String autherId;
  static String recipeId;
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(12),
        children: [
          ...comments.map(designComment).toList(),
        ].reversed.toList());
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

      data.docs.forEach((doc) {
        recipeId = doc["recipeId"];

        // add each comment doc in database to the list to show them in the screen
        print(doc["commentOwner"]);
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
        ));
      });
      if (this.mounted) {
        setState(() {
          comments;
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

  Widget repordelIcon(String commentRef) {
    final FirebaseAuth usId = FirebaseAuth.instance;
    final _currentUser = usId.currentUser.uid;

    return IconButton(
        onPressed: () {
          _DeletFirestoreComment(commentRef);
        },
        icon: Icon(
          Icons.delete_outline,
          size: 20,
          color: Colors.red,
        ));
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
                  width: 20,
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
            Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      );
}
