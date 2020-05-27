import 'package:flutter/material.dart';

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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      itemBuilder: (BuildContext context) =><PopupMenuEntry<String>> [

        PopupMenuItem(
          value:"None",
          child: Text('None'),

        ),
        PopupMenuItem(
          value:"One",
          child: Text('One'),

        ),
        PopupMenuItem(
          value:"Two",
          child: Text('Two'),
        ),
        PopupMenuItem(
          value:"Three",
          child: Text('Three'),
        ),

      ],
      child: Icon(
        Icons.label_outline
        ,size: 40.0,
        color: Colors.blueGrey,
      ),
    );
  }
}

