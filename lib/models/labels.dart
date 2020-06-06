class Labels{
  int id;
  String label;
  String color;

  Labels({this.label, this.color,this.id});

  Map<String,dynamic> toMap(){
    return {
      'label':label,
      'color':color,
    };
  }


  @override
  String toString() {
    return 'Labels{id: $id, label: $label, color: $color}';
  }

  static Labels fromMap(Map<String,dynamic> map){
    return Labels(
        id:map['id'],
        label: map['label'],
        color: map['color'],

    );
  }

}