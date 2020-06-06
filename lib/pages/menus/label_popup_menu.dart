import 'package:firebaseapp/models/labels.dart';
import 'package:firebaseapp/pages/custom_colors/custom_color.dart';
import 'package:firebaseapp/services/offline_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});
  String title;
  IconData icon;
}


class LabelPopMenu extends StatefulWidget {

  final void Function(String value) updateParentLabel;
  LabelPopMenu({this.updateParentLabel});

  @override
  _LabelPopMenuState createState() => _LabelPopMenuState();


}

class _LabelPopMenuState extends State<LabelPopMenu> {

  List _labels;
  setValues() async{
    String table="labels";
    List<Map<String,dynamic>> result;




    result = await DB.query(table);
    _labels = result.map((item)=>Labels.fromMap(item)).toList();
    if(_labels.isEmpty){
      await DB.insert(table, Labels(label: "One",color: "0xff5E35B1"));
      await DB.insert(table, Labels(label: "Two",color: "0xffD81B60"));
      await DB.insert(table, Labels(label: "Three",color: "0xffFFB300"));

      result = await DB.query(table);
      _labels = result.map((item)=>Labels.fromMap(item)).toList();
    }
  }

  clearDatabase() async{
    String table="labels";
    List<Map<String,dynamic>> result;
    result = await DB.query(table);
    _labels = result.map((item)=>Labels.fromMap(item)).toList();
    _labels.forEach((element) {
      DB.delete(table, element);
    });

  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    setValues();
//    clearDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(

      elevation: 10.0,

      onCanceled: () {
        print('You have not chossed anything');
      },
      tooltip: 'This is tooltip',
      onSelected: (val){
        print(val);
        widget.updateParentLabel(val);

      },
//        =><PopupMenuEntry<String>> [
      itemBuilder: (BuildContext context) {

        return _labels.map((e) => PopupMenuItem<String>(
            value: e.id.toString(),
            child: Row(
              children: <Widget>[
                Icon(Icons.brightness_1,color: Color(int.parse(e.color)),),
                SizedBox(width: 10.0,),
                Text(e.label)
              ],

            ),
        )).toList().cast<PopupMenuEntry<String>>();

      },
      child: SvgPicture.asset("assets/svg/tag.svg",height: 25.0,width: 25.0,color: CustomColor.IconGreyColor,),
    );
  }
}

