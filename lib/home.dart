import 'package:dairy_tutorial/AddEditPage.dart';
import 'package:dairy_tutorial/dairy.dart';
import 'package:dairy_tutorial/db.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Dairy> dairyList;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Dairy'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditPage(
                        dairy: Dairy(),
                      ))).then((value) {
            refreshList();
          });
        },
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: dairyList.length,
              itemBuilder: (context, index) {
                Dairy dairy = dairyList[index];
                return Card(
                  elevation: 3,
                  child: ListTile(
                    onTap: (){
                      setState(() {
                        loading = true;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEditPage(
                                      dairy: dairy,
                                    ))).then((value) {
                          refreshList();
                        });
                      });
                    },
                    leading: IconButton(
                      icon: Icon(Icons.view_headline),
                      onPressed: () {
                        showDialog(
                          context: context, 
                          builder: (context){
                           return SimpleDialog(
                             shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.pink,
                              title: Text(dairy.title),
                              children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () {},
                                child: Text(dairy.body),
                              ),
                              SizedBox(height: 20,),
                              MaterialButton(
                                color: Colors.white,
                                child: Text('Cancel'),
                              onPressed: (){
                                Navigator.pop(context);
                              },),
                            ],);
                          });
                      },
                    ),
                    title: Text(dairy.title),
                    subtitle: Text(dairy.body,maxLines: 3,),
                    trailing: Text(dairy.date),
                  ),
                );
              },
            ),
    );
  }

  Future<void> refreshList() async {
    dairyList = await DB().getDairy();
    setState(() => loading = false);
  }
}
