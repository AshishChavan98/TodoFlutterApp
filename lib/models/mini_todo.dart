
class MiniTodo{
  int id;
  String insertionDate;
  String title;

  MiniTodo ({this.id,this.insertionDate,this.title});


  Map<String,dynamic> toMap() {
    return {
      'date':insertionDate ?? '',
      'title':title ?? '',
    };
  }


  @override
  String toString() {
    return 'MiniTodo{id: $id, _insertionDate: $insertionDate, _title: $title}';
  }

  static MiniTodo fromMap(Map<String,dynamic> map){
    return MiniTodo(
      id: map['id'],
      insertionDate: map['date'],
      title: map['title']
    );
  }
}