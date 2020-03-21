// 知识库组件
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';

import './ArticleComponent.dart';

class BankComponent extends StatefulWidget {
  String bankId = '';

  BankComponent (bankId) {
    this.bankId = bankId;
  }

  @override
  _BankComponentState createState() => _BankComponentState(this.bankId);
}

class _BankComponentState extends State<BankComponent> {
  String _bankId = '';
  String _bankTitle = '';
  String _bankDetail = '';
  List<Widget> articleInstList = new List<Widget>();

  _BankComponentState(bankId) {
    this._bankId = bankId;
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    setState(() {
      _bankId = this._bankId;
    });
    getBankDetail();
  }

  void getBankDetail () async {
    var url = '${Config.apiPrefix}/repos/$_bankId';
    var headers = {
      'X-Auth-Token': Config.authToken,
      'User-Agent': Config.userAgent,
    };
    final response = await http.get(url, headers: headers);
    final bankDetail = jsonDecode(response.body);
    if (bankDetail != null && bankDetail['data'] != null && bankDetail['data']['name'] != null) {
      setState(() {
        _bankTitle = bankDetail['data']['name'];
        _bankDetail = bankDetail['data']['toc'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_bankTitle'),
      ),
      body: Center(
        child: GestureDetector(
          child: Text('$_bankDetail'),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new ArticleComponent('845908', '5336403')
              )
            );
          },
        )
      ),
    );
  }
}
