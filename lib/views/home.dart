import 'dart:math';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBox(),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF38B6EB),
                Color(0xFF00A2E6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  SearchBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showSearch(context: context, delegate: HomeSearchDelegate());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 17),
                alignment: Alignment.centerLeft,
                height: 32,
                child: Row(
                  children: [
                    Image.asset('assets/images/search_icon.png', width: 16, height: 16),
                    SizedBox(width: 10),
                    Text('搜索', style: TextStyle(fontSize: 12, color: Color(0xFF999999)))
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
          onTap: () {},
          child: Transform.translate(
            offset: Offset(5, 3),
            child: Image.asset(
              'assets/images/message_icon.png',
              width: 44,
              height: 44,
            ),
          ),
        )
      ],
    );
  }
}

class HomeSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.blue,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          height: 60,
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(fontSize: 20),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: 10,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('老孟 $index'),
          onTap: () {
            query = '老孟 $index';
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: Random().nextInt(5),
    );
  }
}
