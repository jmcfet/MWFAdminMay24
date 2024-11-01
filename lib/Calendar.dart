class CustomCalendar{

  // number of days in month [JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC]
  final List<int> _monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  // check for leap year
  bool _isLeapYear(int year){
    if(year % 4 == 0){
      if(year % 100 == 0){
        if(year % 400 == 0) return true;
        return false;
      }
      return true;
    }
    return false;
  }
  List<Calendar> getJustMonthCalendar(DateTime date, List<String> existingstatus, {StartWeekDay startWeekDay = StartWeekDay.sunday}) {
    // validate
    List<Calendar> calendar = [];
    try {
    if ( date.month < 1 ||
        date.month > 12) throw ArgumentError('Invalid year or month');
    int month = date.month;
    int year = date.year;
    
    // used for previous and next month's calendar days
    int otherYear;
    int otherMonth;
    int leftDays;
    bool bNewUser = false;
    // get no. of days in the month
    // month-1 because _monthDays starts from index 0 and month starts from 1
    int totalDays = _monthDays[month - 1];
    // if this is a leap year and the month is february, increment the total days by 1
    if(_isLeapYear(year) && month == DateTime.february) totalDays++;
    if (existingstatus.length == 0)    //a new user has no day info so assume always available
      bNewUser = true;
    // get this month's calendar days
    for(int i=0; i<totalDays; i++){
      int state1 = bNewUser == true ? 0 : int.parse(existingstatus[i+1]);
      calendar.add(
        Calendar(
          // i+1 because day starts from 1 in DateTime class
            date: DateTime(year, month, i+1),
            thisMonth: true,
            state: state1
        ),
      );
    }
   
    } catch (e) {
      print(e);
      
    }
     return calendar;
  }


    /// get the month calendar
  /// month is between from 1-12 (1 for January and 12 for December)
  List<Calendar> getMonthCalendar(int month, int year, List<String> existingstatus,int defaultStatus, {StartWeekDay startWeekDay = StartWeekDay.sunday}){

    // validate
    if(year == null || month == null || month < 1 || month > 12) throw ArgumentError('Invalid year or month');

    List<Calendar> calendar = <Calendar>[];

    // used for previous and next month's calendar days
    int otherYear;
    int otherMonth;
    int leftDays;
    bool bNewUser = false;
    // get no. of days in the month
    // month-1 because _monthDays starts from index 0 and month starts from 1
    int totalDays = _monthDays[month - 1];
    // if this is a leap year and the month is february, increment the total days by 1
    if(_isLeapYear(year) && month == DateTime.february) totalDays++;
    if (existingstatus.length == 0)    //a new user has no day info so assume always not available
       bNewUser = true;
    // get this month's calendar days
    for(int i=0; i<totalDays; i++){
      int state1 = defaultStatus;
        if (!bNewUser )
            state1 = int.parse(existingstatus[i+1]);
 //     int state1 = bNewUser == true ? defaultStatus : int.parse(existingstatus[i+1]);
      calendar.add(
        Calendar(
          // i+1 because day starts from 1 in DateTime class
          date: DateTime(year, month, i+1),
          thisMonth: true,
          state: state1
        ),
      );
    }

    // fill the unfilled starting weekdays of this month with the previous month days
    if(
    (startWeekDay == StartWeekDay.sunday && calendar.first.date!.weekday != DateTime.sunday) ||
        (startWeekDay == StartWeekDay.monday && calendar.first.date!.weekday != DateTime.monday)
    ){
      // if this month is january, then previous month would be decemeber of previous year
      if(month == DateTime.january){
        otherMonth = DateTime.december; // _monthDays index starts from 0 (11 for december)
        otherYear = year-1;
      }
      else{
        otherMonth = month - 1;
        otherYear = year;
      }
      // month-1 because _monthDays starts from index 0 and month starts from 1
      totalDays = _monthDays[otherMonth - 1];
      if(_isLeapYear(otherYear) && otherMonth == DateTime.february) totalDays++;

      leftDays = totalDays - calendar.first.date!.weekday + ((startWeekDay == StartWeekDay.sunday) ? 0 : 1);

      for(int i=totalDays; i>leftDays; i--){
        calendar.insert(0,
          Calendar(
            date: DateTime(otherYear, otherMonth, i),
            prevMonth: true,
          ),
        );
      }
    }

    // fill the unfilled ending weekdays of this month with the next month days
    if(
    (startWeekDay == StartWeekDay.sunday && calendar.last.date!.weekday != DateTime.saturday) ||
        (startWeekDay == StartWeekDay.monday && calendar.last.date!.weekday != DateTime.sunday)
    ){
      // if this month is december, then next month would be january of next year
      if(month == DateTime.december){
        otherMonth = DateTime.january;
        otherYear = year+1;
      }
      else{
        otherMonth = month+1;
        otherYear = year;
      }
      // month-1 because _monthDays starts from index 0 and month starts from 1
      totalDays = _monthDays[otherMonth-1];
      if(_isLeapYear(otherYear) && otherMonth == DateTime.february) totalDays++;

      leftDays = 7 - calendar.last.date!.weekday - ((startWeekDay == StartWeekDay.sunday) ? 1 : 0);
      if(leftDays == -1) leftDays = 6;

      for(int i=0; i<leftDays; i++){
        calendar.add(
          Calendar(
            date: DateTime(otherYear, otherMonth, i+1),
            nextMonth: true,
          ),
        );
      }
    }

    return calendar;

  }
  /// get the month calendar
  /// month is between from 1-12 (1 for January and 12 for December) . we will exclude days other than
  /// M-W-F and those days that already have matchs
  List<Calendar> getMonthCalendar1(int month, int day,int year, {StartWeekDay startWeekDay = StartWeekDay.sunday}){

    // validate
    if(year == null || month == null || month < 1 || month > 12) throw ArgumentError('Invalid year or month');

    List<Calendar> calendar = []  ;

    // used for previous and next month's calendar days
    int otherYear;
    int otherMonth;
    int leftDays;

    // get no. of days in the month
    // month-1 because _monthDays starts from index 0 and month starts from 1
    int totalDays = _monthDays[month - 1];
    // if this is a leap year and the month is february, increment the total days by 1
    if(_isLeapYear(year) && month == DateTime.february) totalDays++;

    // get this month's calendar days
    for(int i=0; i<totalDays; i++){
      DateTime temp = DateTime(year, month, i+1);
      if ((temp.weekday == 1 ||
          temp.weekday == 3 ||
          temp.weekday == 5) && i >= day-1
      )
      calendar.add(
        Calendar(
          // i+1 because day starts from 1 in DateTime class
          date: DateTime(year, month, i+1),
          thisMonth: true,
        ),
      );
    }



    return calendar;

  }

}


class Calendar{
  final DateTime? date;
  final bool thisMonth;
  final bool prevMonth;
  final bool nextMonth;
  int state;
  Calendar({
    this.date = null,
    this.thisMonth = false,
    this.prevMonth = false,
    this.nextMonth = false,
    this.state = 0
  });
}

enum StartWeekDay {sunday, monday}