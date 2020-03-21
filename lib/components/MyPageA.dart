import 'package:flutter/material.dart';

class MyPageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyPageAAA'),
      ),
      body: Center(
        child: GestureDetector(
          child: Text('返回上一个页面'),
          onTap: () {
            Navigator.pop(context);
          }
        )),
    );
  }
}
