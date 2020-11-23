class Dairy {
  int id;
  String title,body,date;

  Dairy();

  Dairy.fromMap(Map<String, dynamic> map){
    id = map['id'];
    title = map['title'];
    body = map['body'];
    date = map['date'];
  }

  toMap(){
    return {
      'id' : id,
      'title' : title,
      'body' : body,
      'date' : date,
    };
  }
}