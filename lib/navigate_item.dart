import 'dart:async';
import 'package:flutter/material.dart';
import 'db_operation.dart';
import 'add_item.dart';
import 'main.dart';
class MyHomePage2 extends StatefulWidget {
  MyHomePage2({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  bool IsLoadingFinished=false;
  bool IsThereAnyCheklist=false;
  List<Icon> Reming=[Icon(Icons.check,size: 35.0,color: Colors.black12,),Icon(Icons.check,size: 35.0,color: Colors.lightBlue,)];

  DbOperation db=new DbOperation();
  List defaultS=new List();

  void initState() {

    super.initState();
    Timer(Duration(seconds: 1), () {
      db.openDb().then((onValue1){
        db.ItemSelect(onValue1,widget.title).then((onValue3){
          IsLoadingFinished=true;
          setState((){});
          if(onValue3!=null && onValue3.length>0){
            IsThereAnyCheklist=true;
            setState((){});
            defaultS=onValue3;
            print("q1="+defaultS.toString());
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(

        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (context) => MyHomePage());
            Navigator.pushReplacement(context, route);
          },
        ),
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title,),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (context) => MyHomePageAdd(showName: false,titleName:widget.title ,update: false,));
              Navigator.pushReplacement(context, route);
              /*       Navigator.push(
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
        child: IsLoadingFinished ? (IsThereAnyCheklist ? ListView.separated(
          padding: const EdgeInsets.all(3),
          itemCount: defaultS.length,
          itemBuilder: (BuildContext context, int index) {
            return  GestureDetector(
                onTap: (){
                  /*  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp3()),
                );*/
                },
                child:  ListTile(
                  leading: Reming[defaultS[index].completed],
                  title: Text(defaultS[index].name,
                    style: TextStyle(fontSize: 23),
                  ),
                  subtitle: Text(defaultS[index].time),
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
                              Route route = MaterialPageRoute(builder: (context) => MyHomePageAdd(showName: false,
                                titleName:widget.title,update: true,titlenameitem: defaultS[index].name,
                                id:defaultS[index].id ,time:defaultS[index].time,Remindsa: defaultS[index].completed,));
                              Navigator.pushReplacement(context, route);
                            }
                        )
                      ]),
                )
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ) : Text("None" ,style: TextStyle(fontSize: 23),) ): new CircularProgressIndicator()
      ),
    );
  }
}