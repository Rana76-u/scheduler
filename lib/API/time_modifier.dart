import 'package:flutter/material.dart';

String localizeTimeToString(TimeOfDay timeOfDay) {

  int hour = timeOfDay.hour;
  int minute = timeOfDay.minute;
  DayPeriod period = timeOfDay.period;

  if(hour > 12){
    hour = (12 - hour).abs();
  }

  int hl = hour.toString().length;
  int ml = minute.toString().length;

  return '${hl < 2 ? '0${hour.abs()}' : hour.abs()}'
      ':${ml < 2 ? '0$minute' : minute}'
      ' ${period.name}'
  ;
}

String compareTime(TimeOfDay startTime, TimeOfDay endTime) {
  final now = TimeOfDay.now();

  if(now.hour < startTime.hour){
    return 'Next';
  }
  else if(now.hour == startTime.hour){
    return 'Now';
  }
  else if(now.hour == endTime.hour){
    if(now.minute <= endTime.minute){
      return 'Now';
    }
    else{
      return 'Done';
    }
  }// if(now.hour > endTime.hour)
  else{
    return 'Done';
  }

}