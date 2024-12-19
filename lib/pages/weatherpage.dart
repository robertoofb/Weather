import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/sevices/weather_sevice.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  // api key
  final _weatherSevice = WeatherSevice('6e90c008558ffc3cde1f122c73c77f91');
  Weather? _weather;

  //fetch the weather data
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherSevice.getCurrentCity();

    // get the weather for the city
    try {
      final weather = await _weatherSevice.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default animation

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'fog':
      case 'dust':
      case 'haze':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "Loading city..."),

            //weather condition lottie animation
            LottieBuilder.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature
            Text('${_weather?.temperature.round()} °C'),

            //weather condition
            Text(_weather?.mainCondition ?? "Loading weather..."),
          ],
        ),
      ),
    );
  }
}
