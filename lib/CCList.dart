import 'package:flutter/material.dart';
import 'package:flutter_api/CCData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CCList extends StatefulWidget{




  @override
  State<StatefulWidget> createState() {

    return CCListState();

  }
}



class CCListState extends State<CCList>{
  List<CCData> data = [];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: Container(

            child: ListView(
              children: _buildList(),
            ),
        ),

        floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _loadCC(),
    ),
    );
  }


  _loadCC() async{
    final response = await http.get('https://api.unsplash.com/photos/?client_id=cf49c08b444ff4cb9e4d126b7e9f7513ba1ee58de7906e4360afc1a33d1bf4c0');
    if(response.statusCode == 200){
      var allData = (json.decode(response.body));
      var ccDataList = List<CCData>();
      allData.forEach((dynamic val){
        var record = CCData(name: val['user']['name'] ?? '', bio: val['alt_description'] ?? '', small: val['urls']['small'] ?? '');

        ccDataList.add(record);
      });
            setState((){
              data = ccDataList;
            });
    }
}

  List<Widget> _buildList(){
    return
      data.map((CCData f) => ListTile(
        title: Text(f.name),
        subtitle: Text(f.bio),
        leading:  Image.network(f.small),
        onTap: (){
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => DetailPage(f.name, f.small))
          );
        },
    )).toList();

  }
  @override
  void initState(){
    super.initState();
        _loadCC();
  }



}


class DetailPage extends StatelessWidget {
  final String user;
  final String img;

  DetailPage(this.user, this.img);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(user),
      ),
        body: Center(
          child: Image.network(img),
      ),
      );

  }
}