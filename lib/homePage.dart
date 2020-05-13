import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:convert';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int temperature;
  int woeid = 44418;
  String apikey = '4ddc41225fe319768d3bbc7ffd07412f';
  String errorMessage = '';
  String abbreviation = '';
  String location = "London";
  String weather = "clear";
  String locationAPI = 'https://www.metaweather.com/api/location/';
  String searchAPI = 'https://www.metaweather.com/api/location/search/?query=';

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getSearchAPI(String input) async {
    try {
      var searchResult = await http.get(searchAPI + input);
      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errorMessage = '';
      });
    } catch (error) {
      setState(() {
        errorMessage = "Sorry, no data available about this city";
      });
    }
  }

  void getLocation() async {
    var locationResult = await http.get(locationAPI + woeid.toString());
    var result = json.decode(locationResult.body);
    var consolidatedWeather = result["consolidated_weather"];
    var data = consolidatedWeather[0];
    setState(() {
      temperature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ', '').toLowerCase();
      abbreviation = data["weather_state_abbr"];
    });
  }

  void onTextFieldSubmitted(String input) async {
    await getSearchAPI(input);
    await getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.height - 60.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35.0),
                    bottomRight: Radius.circular(35.0)),
                image: DecorationImage(
                    image: AssetImage('assets/images/$weather.jpg'),
                    fit: BoxFit.cover)),
            child: temperature == null
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                  ))
                : Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Center(
                            child: Image.network(
                              'https://www.metweather.com/static/img/weather/png/' +
                                  abbreviation +
                                  '.png',
                              width: 100,
                            ),
                          ),
                          Center(
                              child: Text(
                            temperature.toString() + "C",
                            style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.black26,
                                fontSize: 60.0),
                          )),
                          Center(
                              child: Text(
                            location,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40.0,
                                backgroundColor: Colors.black26),
                          ))
                        ]),
                        Column(children: <Widget>[
                          Container(
                              width: 300,
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
                                    prefixIcon: Icon(Icons.search,
                                        color: Colors.deepOrange)),
                              )),
                          Text(errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: Platform.isAndroid ? 15.0 : 20.0))
                        ])
                      ],
                    ))),
      ],
    ));
  }
}
