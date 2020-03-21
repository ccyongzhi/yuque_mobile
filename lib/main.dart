import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'dart:io';
import 'package:http/http.dart' as http;
import './config/config.dart';

import './components/BankComponent.dart';

// void main() => runApp(MyApp());
void main() =>
    runApp(MaterialApp(home: MyApp(), routes: <String, WidgetBuilder>{
      // '/a': (BuildContext context) => MyPageA(),
    }));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '语雀移动版'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String _htmlText = '';
  int _currentTabIndex = 0;
  var _bankInstList = new List<Widget>();

  void _setHtmlText() async {
    final headers = {
      'X-Auth-Token': Config.authToken,
      'User-Agent': Config.userAgent,
    };
    final String userUrl = '${Config.apiPrefix}/user';
    final responseUser = await http.get(userUrl, headers: headers);
    final userInfo = jsonDecode(responseUser.body)['data'];
    final userId = userInfo['id'].toString();
    final String bankUrl = '${Config.apiPrefix}/users/$userId/repos';
    final responseBank = await http.get(bankUrl, headers: headers);
    final List bankInfoList = jsonDecode(responseBank.body)['data'];
    print(bankInfoList);
    List<Widget> bankInstList = new List<Widget>();
    bankInfoList.forEach((item) => {
      bankInstList.add(
        GestureDetector(
          child: Text('${item["name"]}'),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new BankComponent(item['id'].toString())
              )
            );
          },
        )
      )
    });
    setState(() {
      // _htmlText = bankInfoList.toString();
      _bankInstList = bankInstList;
    });
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    _setHtmlText();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new ListView(
        children: _bankInstList,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTabIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('知识库'),
            icon: Icon(Icons.bookmark),
          ),
          BottomNavigationBarItem(
            title: Text('我的'),
            icon: Icon(Icons.person),
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }
}
