import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

/// 메인
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Widget _buildDiaryList(Diary diary) {
    return ListTile(
      leading: Container(
        width: 100,
        child: diary.image,
      ),
      title: Text(diary.date + '    ' + diary.title),
      subtitle: Text(diary.content),
      trailing: Icon(Icons.more_vert),
      isThreeLine: true,
    );
  }

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
          SliverList(
              delegate: SliverChildListDelegate(_diaryList.map((e) => _buildDiaryList(e)).toList()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () async{
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WriteDiaryPage()),
          );
          setState(() {

          });
        },
      ),
    );
  }
}

/// 다이어리 작성
class WriteDiaryPage extends StatefulWidget {
  @override
  _WriteDiaryPageState createState() => _WriteDiaryPageState();
}

class _WriteDiaryPageState extends State<WriteDiaryPage> {
  Weather selectedWeather;
  Emotion selectedEmotion;

  DateTime _date = DateTime.now();

  PickedFile _image;
  final picker = ImagePicker();

  var _titleController = TextEditingController();
  var _contentController = TextEditingController();

  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  setDate(DateTime date) {
    var dateParse = DateTime.parse(date.toString());
    var formattedDate =
        "${dateParse.year}.${dateParse.month.toString().padLeft(2, '0')}.${dateParse.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = PickedFile(pickedFile.path);
    });
  }

  Widget setWeather() {
    return DropdownButton<Weather>(
      hint: Text('날씨'),
      isExpanded: true,
      value: selectedWeather,
      onChanged: (Weather value) {
        setState(() {
          selectedWeather = value;
        });
      },
      items: _weatherList.map((Weather weather) {
        return DropdownMenuItem<Weather>(
            value: weather,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: weather.iconWeather,
                ),
                SizedBox(width: 1),
                Text(weather.strWeather)
              ],
            ));
      }).toList(),
    );
  }

  Widget setEmotion() {
    return DropdownButton<Emotion>(
      hint: Text('기분'),
      isExpanded: true,
      value: selectedEmotion,
      onChanged: (Emotion value) {
        setState(() {
          selectedEmotion = value;
        });
      },
      items: _emotionList.map((Emotion emotion) {
        return DropdownMenuItem<Emotion>(
            value: emotion,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[emotion.iconEmotion, Text(emotion.strEmotion)],
            ));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              _addDiary(Diary(
                  setDate(_date),
                  selectedWeather,
                  selectedEmotion,
                  _titleController.text,
                  Image.file(File(_image.path)),
                  _contentController.text));

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
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
              controller: _titleController,
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
                decoration: myBoxDecoration(),
                height: 250,
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: _image == null
                          ? Text('No image')
                          : Image.file(
                              File(_image.path),
                              alignment: Alignment.center,
                            ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_photo_alternate,
                          size: 40,
                        ),
                        onPressed: getImage,
                      ),
                    )
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: TextField(
              controller: _contentController,
              maxLength: 500,
              maxLines: 25,
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                  hintText: '내용'),
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)));
  }

  void _addDiary(Diary diary) {
    _diaryList.add(diary);
  }
}

/// 날씨 클래스
class Weather {
  String strWeather;
  Icon iconWeather;

  Weather(this.strWeather, this.iconWeather);
}

/// 기분 클래스
class Emotion {
  String strEmotion;
  Icon iconEmotion;

  Emotion(this.strEmotion, this.iconEmotion);
}

/// 다이어리 클래스
class Diary {
  String date;
  Weather weather;
  Emotion emotion;
  String title;
  Image image;
  String content;

  Diary(this.date, this.weather, this.emotion, this.title, this.image,
      this.content);
}

// 다이어리 목록을 저장할 리스트
final _diaryList = <Diary>[];
final _weatherList = <Weather>[
  Weather('맑음', Icon(WeatherIcons.day_sunny)),
  Weather('흐림', Icon(WeatherIcons.cloudy)),
  Weather('비', Icon(WeatherIcons.rain)),
  Weather('눈', Icon(WeatherIcons.snow))
];
final _emotionList = <Emotion>[
  Emotion('행복', Icon(Icons.sentiment_very_satisfied)),
  Emotion('좋음', Icon(Icons.sentiment_satisfied)),
  Emotion('그냥', Icon(Icons.sentiment_neutral)),
  Emotion('나쁨', Icon(Icons.sentiment_dissatisfied)),
  Emotion('최악', Icon(Icons.sentiment_very_dissatisfied)),
];
