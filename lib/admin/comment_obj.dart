import 'package:flutter/material.dart';

class CommentObj {
  String commentRef;
  String commentOwner;
  String recipeId;
  String commentDate;
  String commentText;
  int bullying;
  int fraudulent;
  int unethical;
  int IDontLike;
  int no_reports;
  List<String> user_already_reported;
  CommentObj({
    this.commentRef,
    this.commentOwner,
    this.recipeId,
    this.commentDate,
    this.commentText,
    this.bullying,
    this.fraudulent,
    this.unethical,
    this.IDontLike,
    this.no_reports,
    this.user_already_reported,
  });
}
