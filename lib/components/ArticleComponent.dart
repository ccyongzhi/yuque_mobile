// 知识库组件
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';

class ArticleComponent extends StatefulWidget {
  String repoId = '';
  String articleId = '';

  ArticleComponent (repoId, articleId) {
    this.repoId = repoId;
    this.articleId = articleId;
  }

  @override
  _ArticleComponentState createState() => _ArticleComponentState(this.repoId, this.articleId);
}

class _ArticleComponentState extends State<ArticleComponent> {
  String _repoId = '';
  String _articleId = '';
  String _articleTitle = '';
  String _articleDetail = '';
  List<Widget> articleInstList = new List<Widget>();

  _ArticleComponentState(repoId, articleId) {
    this._repoId = repoId;
    this._articleId = articleId;
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    setState(() {
      _articleId = this._articleId;
    });
    getArticleDetail();
  }

  void getArticleDetail () async {
    var url = '${Config.apiPrefix}/repos/$_repoId/docs/$_articleId';
    var headers = {
      'X-Auth-Token': Config.authToken,
      'User-Agent': Config.userAgent,
    };
    final response = await http.get(url, headers: headers);
    final articleDetail = jsonDecode(response.body);
    if (articleDetail != null && articleDetail['data'] != null && articleDetail['data']['title'] != null) {
      setState(() {
        _articleTitle = articleDetail['data']['title'].toString();
        _articleDetail = articleDetail['data']['body_html'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_articleTitle'),
      ),
      body: Center(
        child: Text('$_articleDetail'),
      ),
    );
  }
}
