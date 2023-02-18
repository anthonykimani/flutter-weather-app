import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/views/additional_information.dart';
import 'package:weather_app/views/current_weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherApiClient client = WeatherApiClient();
  Weather? data = Weather();
  String location = "Nairobi";
  String newLocation = "";

  Future<void> getData() async {
    data = await client.getCurrentWeather(location);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf9f9f9),
        appBar: AppBar(
          backgroundColor: Color(0xFFf9f9f9),
          elevation: 0.0,
          title: Text("Weather App", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              children: [
                FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //creating a custom widget
                          currentWeather(Icons.wb_sunny_rounded,
                              "${data!.temp}°", "${data!.cityName}"),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Additional Information",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Color(0xdd212121),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 20.0,
                          ),
                          additionalInformation(
                              "${data!.wind}",
                              "${data!.humidity}",
                              "${data!.pressure}",
                              "${data!.feels_like}"),
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container();
                  },
                ),
                TextField(
                  onChanged: (text) {
                    newLocation = text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search Weather by City',
                  ),
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    location = newLocation;
                  });
                }, child: Text("Search")),
              ],
            ),
          ),
        ),
    );
  }
}
