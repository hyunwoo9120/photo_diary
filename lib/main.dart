import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://images.unsplash.com/photo-1528041119984-da3a9f8d04d1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1256&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Text('diary list'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WriteDiary()),
          );
        },
      ),
    );
  }
}

class WriteDiary extends StatefulWidget {
  @override
  _WriteDiaryState createState() => _WriteDiaryState();
}

class _WriteDiaryState extends State<WriteDiary> {
  DateTime _date = DateTime.now();

  String _weather;
  String _emotion;

  setDate(DateTime date) {
    var dateParse = DateTime.parse(date.toString());
    var formattedDate =
        "${dateParse.year}.${dateParse.month.toString().padLeft(2, '0')}.${dateParse.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  Widget setWeather() {
    DropdownButton _itemDown() => DropdownButton<String>(
          hint: Text('날씨'),
          value: _weather,
          isExpanded: true,
          onChanged: (String newWeather) {
            setState(() {
              _weather = newWeather;
            });
          },
          items: [
            DropdownMenuItem(
              value: "1",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Icon(WeatherIcons.day_sunny),
                  ),
                  Text(
                    "맑음",
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "2",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Icon(WeatherIcons.cloudy),
                  ),
                  Text(
                    "흐림",
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "3",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Icon(WeatherIcons.rain),
                  ),
                  Text(
                    "비",
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "4",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Icon(WeatherIcons.snow),
                  ),
                  Text(
                    "눈",
                  ),
                ],
              ),
            ),
          ],
        );

    return _itemDown();
  }

  Widget setEmotion() {
    DropdownButton _itemDown() => DropdownButton<String>(
          hint: Text('기분'),
          value: _emotion,
          isExpanded: true,
          onChanged: (String newEmotion) {
            setState(() {
              _emotion = newEmotion;
            });
          },
          items: [
            DropdownMenuItem(
              value: "0",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.sentiment_very_satisfied),
                  Text(
                    "행복",
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "1",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.sentiment_satisfied),
                  Text(
                    "좋음",
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "2",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.sentiment_neutral),
                  Text(
                    "그냥",
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "3",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.sentiment_dissatisfied),
                  Text(
                    "나쁨",
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "4",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.sentiment_very_dissatisfied),
                  Text(
                    "최악",
                  ),
                ],
              ),
            ),
          ],
        );

    return _itemDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('write'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    setDate(_date),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Future<DateTime> selectedDate = showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030));
                    selectedDate.then((selectedTime) {
                      setState(() {
                        _date = selectedTime;
                      });
                    });
                  },
                ),
              ),
              Container(
                width: 100,
                child: setWeather(),
              ),
              Container(
                width: 100,
                child: setEmotion(),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: TextField(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  hintText: '제목'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Container(
              alignment: Alignment.bottomRight,
              decoration: myBoxDecoration(),
              height: 200,
              child: IconButton(
                icon: Icon(
                  Icons.add_photo_alternate,
                  size: 40,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
        border: Border.all(
          width: 3,
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)));
  }
}
