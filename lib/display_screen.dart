import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:simpleweather/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  TextEditingController t1 = TextEditingController();
  bool isLoading = false;
  var name;
  var search;
  var temp;
  var place;
  var humidity;
  var description;

  // @override
  // void initState() {
  //   getData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.black),
        ),
        color: Colors.white,
        child: Container(
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
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    height: 45,
                    child: TextField(
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
                          hintText: 'search city',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.white,
                          filled: true),
                    ),
                  ),
                  Text('WEATHER', style: TitleTextStyle),
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
                    height: 60,
                  ),
                  Container(
                    height: 33,
                    width: 150,
                    child: RaisedButton(
                        color: Colors.blueAccent,
                        shape: StadiumBorder(),
                        child: Text(
                          'Search',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (t1.text.isEmpty) {
                            // setState(() {
                            //   isLoading = false;
                            // });
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Text("Search City can't be empty"),
                                title: Text("Opps!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                        );
                                      },
                                      child: Text("cancel"))
                                ],
                              ),
                            );
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                          }

                          name = t1.text;
                          t1.clear();
                          await getData();
                          setState(() {
                            isLoading = false;
                          });
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: isLoading,
      ),
    );
  }

  getData() async {
    http.Response response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$name&units=metric&appid=dccedd8fd95ec95942e4bb726d5dc34e'));
    if (response.statusCode == 200) {}
    setState(() {
      this.temp = jsonDecode(response.body)['main']['temp'];

      this.place = jsonDecode(response.body)['name'];
      this.humidity = jsonDecode(response.body)['main']['humidity'];
      this.description = jsonDecode(response.body)['weather'][0]['description'];
    });
  }
}
