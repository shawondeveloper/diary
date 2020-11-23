import 'package:dairy_tutorial/dairy.dart';
import 'package:dairy_tutorial/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEditPage extends StatefulWidget {
  final Dairy dairy;
  AddEditPage({this.dairy});
  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  TextEditingController title, body;
  bool loading = false, editmode = false;

  var curnDate = DateFormat.yMd().add_jm().format(DateTime.now());

  @override
  void initState() {
    super.initState();
    title = TextEditingController();
    body = TextEditingController();
    if (widget.dairy.id != null) {
      editmode = true;
      title.text = widget.dairy.title;
      body.text = widget.dairy.body;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(editmode ? 'EDIT' : 'ADD'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              save();
            },
          ),
          if (editmode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                delete();
              },
            ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: title,
                    decoration: InputDecoration(labelText: 'Enter Title'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: body,
                    decoration: InputDecoration(labelText: 'Enter Body'),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> save()async{
    if (title != null) {
      widget.dairy.date = curnDate;
      widget.dairy.title = title.text;
      widget.dairy.body = body.text;
      if (editmode) await DB().update(widget.dairy);
      else await DB().save(widget.dairy);
    } 
    Navigator.pop(context);
    setState(() => loading = false);
  }

  Future<void> delete() async{
    DB().delete(widget.dairy);
    setState(() {
      loading = false;
    });
    Navigator.pop(context);
  }


}
