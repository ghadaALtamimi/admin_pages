import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReprtedAccount {
  String username;
  String userId;
  int bullying;
  int fraudulent;
  int unethical;
  int IDontLike;
  int no_reports;
  String reason;
  bool Ignore;
  List<String> user_already_reported;
  ReprtedAccount(
      {this.username,
      this.userId,
      this.bullying,
      this.fraudulent,
      this.unethical,
      this.IDontLike,
      this.no_reports,
      this.user_already_reported,
      this.Ignore,
      this.reason});
}
