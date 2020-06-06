import 'package:firebaseapp/pages/custom_colors/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) setReminder;
  DatePicker({this.setReminder});
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {

    DateTime selectedDate = DateTime.now();

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          widget.setReminder(selectedDate);
        });
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
//          Text("${selectedDate.toLocal()}".split(' ')[0]),
//          SizedBox(height: 20.0,),
          GestureDetector(
              onTap: (){
                print("Calendar Date Tapped");
                _selectDate(context);
              },
              child: SvgPicture.asset("assets/svg/calendar.svg",height: 25.0,width: 25.0,color:CustomColor.IconGreyColor)
          )
        ],
      ),
    );
  }
}

class TimePicker extends StatefulWidget {
  final Function(TimeOfDay) setTime;
  TimePicker({this.setTime});
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {

    TimeOfDay selectedTime = TimeOfDay.now();

    Future<Null> _selectDate(BuildContext context) async {
      final TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: 0,minute: 0),
      );
      if (picked != null && picked != selectedTime)
        setState(() {
          selectedTime = picked;
          widget.setTime(selectedTime);
        });
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
//          Text("${selectedDate.toLocal()}".split(' ')[0]),
//          SizedBox(height: 20.0,),
          GestureDetector(
              onTap: (){
                print("Time Tapped");
                _selectDate(context);
              },
              child: SvgPicture.asset("assets/svg/clock.svg",height: 25,width: 25,color: CustomColor.IconGreyColor,)
          )
        ],
      ),
    );
  }
}
