import 'package:aplikasi_cuaca/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import the intl package

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WeatherCubit _weatherCubit;
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    _weatherCubit = BlocProvider.of<WeatherCubit>(context);
    _weatherCubit
        .fetchWeather(); // Fetch weather data when screen is first loaded
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return _buildLoadingScreen(screenWidth, screenHeight);
        }

        if (state is WeatherLoaded) {
          final arrayDataForecastHour =
              state.weather.forecast?.forecastday?.first?.hour ?? [];
          final cuaca = state.weather;
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  width: screenWidth,
                  height: screenHeight,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${cuaca.location!.localtime}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.04,
                                      ),
                                    ),
                                    Text(
                                      '${cuaca.location!.name}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 1, // adjust the scale as needed
                                  child: Switch(
                                    value: _isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        _isSwitched = value;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: Colors.blue[200],
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Colors.blue[300],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.05),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '${cuaca.current?.tempC ?? 'No temperature data'}°',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.2),
                                  ],
                                ),
                                Positioned(
                                    top: 125,
                                    left: 0,
                                    right: 0,
                                    child: Image.network(
                                      'http:${cuaca.current!.condition!.icon!}',
                                      height: 125,
                                      width: 125,
                                      fit: BoxFit
                                          .cover, // atau sesuaikan dengan kebutuhan Anda
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.45,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.08),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Other Time',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            height: screenHeight * 0.2,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: arrayDataForecastHour.length,
                              itemBuilder: (context, index) {
                                final hourData = arrayDataForecastHour[index];
                                String formattedTime = DateFormat('HH:mm')
                                    .format(DateTime.parse(hourData.time!));
                                // ignore: prefer_interpolation_to_compose_strings
                                String iconUrl = 'https:' +
                                    hourData.condition!
                                        .icon!; // Akses properti icon dari objek condition

                                return WeatherItem(
                                  time:
                                      '${formattedTime}', // Make sure this property exists and is properly formatted
                                  icon:
                                      iconUrl, // Replace with actual icon logic
                                  temp:
                                      '${hourData.tempC}°', // Make sure this property exists
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.5, // Adjust the position as needed
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.air,
                                color: Colors.grey, size: screenWidth * 0.08),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              '${cuaca.forecast?.forecastday?.first?.hour?.first?.windMph ?? 'No humidity data'} mp/h',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Wind',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.opacity,
                                color: Colors.grey, size: screenWidth * 0.08),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              '${cuaca.forecast?.forecastday?.first?.hour?.first?.humidity ?? 'No humidity data'}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Humidity',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.cloud,
                                color: Colors.grey, size: screenWidth * 0.08),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              '${cuaca.forecast?.forecastday?.first?.hour?.first?.cloud ?? 'No cloud data'}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Cloud',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom white container
              ],
            ),
          );
        } else {
          return _buildLoadingScreen(screenWidth, screenHeight);
        }
      },
    );
  }
}

class WeatherItem extends StatelessWidget {
  final String time;
  final String icon;
  final String temp;

  const WeatherItem(
      {required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Container(
      width: screenWidth * 0.25,
      margin: EdgeInsets.only(right: screenWidth * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            temp,
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenWidth * 0.012),
          Image.network(icon),
          SizedBox(height: screenWidth * 0.012),
          Text(
            time,
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLoadingScreen(double screenWidth, double screenHeight) {
  return Stack(
    children: [
      Container(
        color: Colors.blue,
        width: screenWidth,
        height: screenHeight,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(height: 16.0),
              Text(
                'Mohon Tunggu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
