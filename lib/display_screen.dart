import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:simpleweather/constants.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  TextEditingController t1 = TextEditingController();
  var name;
  var search;
  var temp;
  var place;
  var humidity;
  var description;

  void getData() async {
    http.Response response = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=$name&units=imperial&appid=dccedd8fd95ec95942e4bb726d5dc34e');
    setState(() {
      this.temp = jsonDecode(response.body)['main']['temp'];
      this.place = jsonDecode(response.body)['name'];
      this.humidity = jsonDecode(response.body)['main']['humidity'];
      this.description = jsonDecode(response.body)['weather'][0]['description'];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/res.jpg'),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text('WEATHER', style: TitleTextStyle),
                    TextField(
                      controller: t1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  t1.text = '';
                                  place = null;
                                  temp = null;
                                  description = null;
                                });
                              }),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.blue,
                          ),
                          hintText: 'Search any City',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.white,
                          filled: true),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      place != null ? place : 'cityName',
                      style: CityNameTexStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(temp != null ? temp.toString() + '\u00b0' : 'Temp',
                        style: TemperatureTextStyle),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      description != null
                          ? description.toString()
                          : 'Description',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      child: RaisedButton(
                          color: Colors.blue,
                          shape: StadiumBorder(),
                          child: Text(
                            'Search',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              name = t1.text;
                              getData();
                            });
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
