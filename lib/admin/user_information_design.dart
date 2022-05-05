import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInformationDesign extends StatelessWidget {
  String userName;
  //String userImage;

  UserInformationDesign(this.userName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
