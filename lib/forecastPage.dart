import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Forecast extends StatefulWidget {
  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  String errorMessage = '';
  String location = '';
  String input = '';
  String apikey = '4ddc41225fe319768d3bbc7ffd07412f';
  int temperature;

  void getsixteenDayAPI(String input) async {
    try {
      var queryParameters = {
        'q': input,
        'appid': '4ddc41225fe319768d3bbc7ffd07412f',
      };

      var uri = Uri.http(
          'samples.openweathermap.org', '/data/2.5/forecast', queryParameters);
      var searchResult = await http.get(uri);

      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result["city"]['name'];
        errorMessage = '';
      });
    } catch (error) {
      setState(() {
        errorMessage = "Sorry, no data available about this city";
      });
    }
  }

  void onTextFieldSubmitted(String input) async {
    await getsixteenDayAPI(input);
  }

  @override
  Widget build(BuildContext context) {
    return (Column(children: <Widget>[
      Container(
          width: 500,
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: TextField(
            onSubmitted: (String input) {
              onTextFieldSubmitted(input);
            },
            style: TextStyle(
                backgroundColor: Colors.black26,
                color: Colors.deepOrange,
                fontSize: 25),
            decoration: InputDecoration(
                hintText: "Search city...",
                hintStyle: TextStyle(
                    backgroundColor: Colors.black26,
                    color: Colors.deepOrange,
                    fontSize: 30.0),
                prefixIcon: Icon(Icons.search, color: Colors.deepOrange)),
          )),
      Text(errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.redAccent,
              fontSize: Platform.isAndroid ? 15.0 : 20.0))
    ]));
  }
}
