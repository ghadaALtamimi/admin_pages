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
  List<String> user_already_reported;
  ReprtedAccount({
    this.username,
    this.userId,
    this.bullying,
    this.fraudulent,
    this.unethical,
    this.IDontLike,
    this.no_reports,
    this.user_already_reported,
  });

  ReprtedAccount.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['userId'];
    bullying = json['bullying'];
    fraudulent = json['fraudulent'];
    unethical = json['unethical'];
    IDontLike = json['IDontLike'];
    no_reports = json['no_reports'];
    user_already_reported = json['user_already_reported'].cast<String>();
  }
}
