import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
class HomeUi extends StatefulWidget{
  String title;
  HomeUi(this.title);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new KlimaticHomeUi(title);
  }
  
}

class KlimaticHomeUi extends State<HomeUi> {
  String title;
  String _defaultCity = "Kanpur";
  KlimaticHomeUi(this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new Container(
              margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: new IconButton(
                  icon: new Icon(Icons.menu),
                  iconSize: 35.0,
                  onPressed: () => nextScreenWorks(context)
              )
          )

        ],
      ),
      body: UpdateTempWidget(_defaultCity),
    );
  }

  Future<Map> getData(String city) async {
    var a = city.split(" ");
    city = a.join("+");
    String url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=b6fbbf8938201b0d9cc79fc32a00aa76&units=metric";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  Widget UpdateTempWidget(String city)
  {
    return new FutureBuilder(
      future: getData(city),
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
        if(snapshot.hasData){
          if(!(snapshot.data.containsKey('message')))
            {
              Map content = snapshot.data;
              return new Stack(
                children: <Widget>[
                  new Image.asset("images/umbrella.png", width: 490.0,
                    height: 1200.0,
                    fit: BoxFit.fill,),
                  new Center(
                      child: new Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(65.0, 35.0, 0, 0),
                          child: new Image.asset("images/light_rain.png")
                      )
                  ),

                  new Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.fromLTRB(8.0, 0, 0, 65.0),
                    child: new Text("Temp : ${content['main']['temp'].toString()} °C\nHumidity : ${content['main']['humidity'].toString()}\nDescription :${content['weather'][0]['main'].toString()}",
                        style: TextStyle(color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600)),
                  ),
                  new Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.fromLTRB(0.0, 20.0, 35.0, 0),
                    child: new Text("${content['name']}", style: TextStyle(color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600)),
                  ),
                ],
              );
            }
          else 
            {
              return new Stack(
                children: <Widget>[
                  new Image.asset("images/umbrella.png", width: 490.0,
                    height: 1200.0,
                    fit: BoxFit.fill,),
                  new Center(child: Text("Entered Wrong Location...",style: TextStyle(fontSize: 30.0,color: Colors.white,fontWeight: FontWeight.w800),))
                ],
              );
            }
        }
        else return new Container();
        }
    );
  }

  Future nextScreenWorks(BuildContext context) async {
    Map result = await Navigator.of(context).push(new MaterialPageRoute<Map>(
        builder: (BuildContext context) => CityChangeScreen())
    );
    if(result.isNotEmpty)
      _defaultCity = result['info'];
  }

}

class CityChangeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CityChangeScreenState();
  }
  
}

class CityChangeScreenState extends State<CityChangeScreen>{
  TextEditingController _cityNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Change City"),
        backgroundColor: Colors.redAccent,
      ),
      body: new Stack(
        children: <Widget>[
          new Image.asset("images/white_snow.png",
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,),
           new Column(children: <Widget>[
             new Padding(padding: EdgeInsets.only(top: 15.0)),
             new Container(
               padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
               child: new TextField(
                 controller: _cityNameController,
                 decoration: InputDecoration(labelText: "Enter City Name",),
               ),
             ),
             new Padding(padding: EdgeInsets.only(top: 15.0)),
             new Container(
               child: new RaisedButton(
                 color: Colors.redAccent,
                 onPressed: (){
                   Navigator.pop(context,{'info':_cityNameController.text});
                 },
                 child: Text("See Temperature",style: TextStyle(color: Colors.white),),
               ),
             )
           ],)

        ],
      ),
    );
  }
  
}

