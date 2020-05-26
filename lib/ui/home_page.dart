import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _API_KEY = '162771559223464';
  final __SECRET_KEY = 'YddN-KDu6NAn16wQkqSSs8TAwUU';
  final __CLOUD_NAME = 'dinguq3pt';

  String _search;
  int _offset = 0;

  Future<Map> _getCloudinary() async {
    http.Response response;
    response = await http.get(
        'https://$_API_KEY:$__SECRET_KEY@api.cloudinary.com/v1_1/$__CLOUD_NAME/resources/image');
    return json.decode(response.body);
    //print(response);
    //print(json.decode(response.body));
  }

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=mrmz2v59GilEue2WMYHeVZ8ZSYxkF6wM&limit=20=0&rating=G');
    } else {
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=mrmz2v59GilEue2WMYHeVZ8ZSYxkF6wM&q=$_search&limit=19&offset=$_offset&rating=G&lang=en');
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCloudinary().then((value) => print(value['resources']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Pesquise aqui',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getCloudinary(),
              builder: (context, snapShot) {
                switch (snapShot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapShot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapShot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(context, snapShot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapShot.data['resources']),
      itemBuilder: (context, index) {
        if (_search == null || index < snapShot.data['data'].length) {
          return GestureDetector(
            child: Image.network(
                snapShot.data['resources'][index]['secure_url'],
                height: 300,
                fit: BoxFit.cover),
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70),
                  Text(
                    'Carregar mais...',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
        }
      },
    );
  }
}
