import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _API_KEY = '162771559223464';
  final _SECRET_KEY = 'YddN-KDu6NAn16wQkqSSs8TAwUU';
  final _CLOUD_NAME = 'dinguq3pt';
  final _MAX_RESULTS = 20;

  Future<Map> _getCloudinary() async {
    http.Response response;
    response = await http.get(
        'https://$_API_KEY:$_SECRET_KEY@api.cloudinary.com/v1_1/$_CLOUD_NAME/resources/image?max_results=$_MAX_RESULTS');
    return json.decode(response.body);
  }

  @override
  void initState() {
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
                  /* _search = text;
                  _offset = 0; */
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

  Widget _createGifTable(context, snapShot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: snapShot.data['resources'].length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Image.network(snapShot.data['resources'][index]['secure_url'],
              height: 300, fit: BoxFit.cover),
        );
      },
    );
  }
}
