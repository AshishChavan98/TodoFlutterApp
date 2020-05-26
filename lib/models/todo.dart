class Todo{
  String documentId;
  String title;
  String task;
  bool completed;

  Todo({this.title,this.task,this.completed=false,this.documentId=''});

  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'task':task,
      'completed':completed,
    };
  }
}