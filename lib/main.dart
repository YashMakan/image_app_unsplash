import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_app_unsplash/splash.dart';

void main() => runApp(One());


class Unsplash extends StatefulWidget {
  @override
  _UnsplashState createState() => _UnsplashState();
}

class _UnsplashState extends State<Unsplash> {
  var data=[];
  int num=1;
  String keyword='';
  TextEditingController t1 = TextEditingController();
  ScrollController grid_controller = ScrollController();

  @override
  void dispose() {
    grid_controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      keyword='Nature';
      t1.text='Nature';
      grid_controller = new ScrollController()..addListener(_scrollListener);
      getjsondata(num,keyword);
    });
  }

  setjsondata(key) async {
    var response= await http.get("https://api.unsplash.com/search/photos?page=1&photos?per_page=20&client_id=o3jJvGH13AlvSVm_NWZ4AQZDRADIEKbrYVflF6zCOTE&query=$key");
    var converted = json.decode(response.body);
    var d=converted["results"];
    var newp=[];
    for(int i = 0; i < d.length; i++){
      newp.add(d[i]["urls"]["regular"]);
    }
    setState(() {
      num=1;
      data=[];
      data=newp;
    });
  }


  getjsondata(pg,keyword) async {
    var response= await http.get("https://api.unsplash.com/search/photos?page=$pg&photos?per_page=20&client_id=o3jJvGH13AlvSVm_NWZ4AQZDRADIEKbrYVflF6zCOTE&query=$keyword");
    var converted = json.decode(response.body);
    var d=converted["results"];
    var newp=[];
    for(int i = 0; i < d.length; i++){
      newp.add(d[i]["urls"]["regular"]);
    }
    setState(() {
      num+=1;
      data.addAll(newp);
    });
  }

  void _scrollListener() {
    print(grid_controller.position.extentAfter);
    if (grid_controller.position.extentAfter % 500==0 ) {
      setState(() {
        num+=1;
        getjsondata(num,keyword);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.menu,size: 25.0,),
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage("https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"),
                    ),
                  ],
                ),
                Container(
                  height: 90.0,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Unsplash",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: 65.0,
                  child: TextFormField(
                    controller: t1,
                    onFieldSubmitted: (val){
                      keyword=val;
                      setjsondata(val);
                    },
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: 'Search photos',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.grey.shade50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.grey.shade50),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Showing results about $keyword",
                          style:TextStyle(
                              color: Colors.black54,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                data.length!=0?SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .6 -10.0,
                    child: StaggeredGridView.countBuilder(
                      controller: grid_controller,
                      crossAxisCount: 4,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context,int index)=>
                          GestureDetector(onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NextPage(img: data[index],i:index)),
                            );
                          },child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                    image: NetworkImage(data[index]),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),),
                      staggeredTileBuilder: (int index)=>
                          StaggeredTile.count(2,index.isEven ? 3 : 1.5),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 20.0,
                    ),
                  ),
                ):Column(children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height/5,),
                  CircularProgressIndicator()
                ],)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class NextPage extends StatefulWidget {
  final String img;
  final int i;
  const NextPage({Key key, this.img, this.i}) : super(key: key);
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.i.isEven?Image.network(
        widget.img,
        fit: BoxFit.fitHeight,
        alignment: Alignment.center,
      ):Image.network(
        widget.img,
        fit: BoxFit.fitWidth,

        alignment: Alignment.center,
      ),
    );;
  }
}
