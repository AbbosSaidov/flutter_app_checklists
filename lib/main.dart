import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navigate_item.dart';
import 'db_operation.dart';
import 'dart:async';
import 'add_item.dart';
import 'package:flutter_picker/flutter_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  bool IsLoadingFinished=false;
  bool IsThereAnyCheklist=false;
  DbOperation db=new DbOperation();
  List defaultS;
  List<IconData> icopns=[Icons.cake,Icons.four_k,Icons.four_k,Icons.four_k,Icons.four_k,Icons.four_k];
  List<PickerItem> icopns2=[PickerItem(text: Icon(Icons.cake)),PickerItem(text: Icon(Icons.business)),
    PickerItem(text: Icon(Icons.local_grocery_store)),PickerItem(text: Icon(Icons.music_note)),
    PickerItem(text: Icon(Icons.trip_origin)),PickerItem(text: Icon(Icons.schedule)),
    PickerItem(text: Icon(Icons.access_alarm)),PickerItem(text: Icon(Icons.account_balance)),
    PickerItem(text: Icon(Icons.face)),PickerItem(text: Icon(Icons.add_circle_outline)),
    PickerItem(text: Icon(Icons.add_a_photo)),PickerItem(text: Icon(Icons.access_time)),
    PickerItem(text: Icon(Icons.adjust)),PickerItem(text: Icon(Icons.close)),];

  void initState(){
    super.initState();
    Timer(Duration(seconds: 1),(){
      db.openDb().then((onValue1){
        db.dogs(onValue1).then((onValue3){
          IsLoadingFinished=true;
          setState((){});
          if(onValue3!=null && onValue3.length>0){
            IsThereAnyCheklist=true;
            setState((){});
            defaultS=onValue3;
            print(defaultS);
            print(DateTime.parse(defaultS[0].time).minute);
          }
        });
      });
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Checklist",),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (context) => MyHomePageAdd(showName: true,update: false,));
              Navigator.pushReplacement(context, route);
                /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePageAdd(title: "Add item",)),
              );*/
            },
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: IsLoadingFinished ?
        IsThereAnyCheklist? ListView.separated(
          padding: const EdgeInsets.all(3),
          itemCount: defaultS.length,
          itemBuilder: (BuildContext context, int index) {
            return  GestureDetector(
              onTap: (){},
              child:  ListTile(
                leading: icopns2[defaultS[index].iconNumber].text,
                title: Text(defaultS[index].texts,
                style: TextStyle(fontSize: 23),
                ),
                //subtitle: Text("There are "),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                        color: Colors.lightBlue,
                        size: 35.0,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black26,
                            size: 19.0,
                          ),
                          onPressed: (){
                            Route route = MaterialPageRoute(builder: (context) => MyHomePage2(title: defaultS[index].texts,));
                            Navigator.pushReplacement(context, route);
                          }
                      )
                    ]),
              )
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ):Text("None" ,style: TextStyle(fontSize: 23),) :
        new CircularProgressIndicator(),
      ),
    );
  }
}
