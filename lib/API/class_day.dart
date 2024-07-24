String getClassDayToString(int index) {
  switch(index) {
    case 0:
      return 'S';
    case 1:
      return 'M';
    case 2:
      return 'T';
    case 3:
      return 'W';
    case 4:
      return 'R';
    case 5:
      return 'F';
    case 6:
      return 'A';
  }
  return '';
}

String nameOfWeekDays(int index) {
  switch(index) {
    case 0:
      return 'Sunday';
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
  }
  return '';
}