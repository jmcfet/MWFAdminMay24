import 'dart:js_util';

import 'package:adminui/models/PlayersinfoandBookedDate.dart';


class BookedDatesResponse {
   List<PlayersinfoandBookedDates> datesandstatus  ;
  String error = '';


  BookedDatesResponse({
    this.datesandstatus = const [],
  });
    
  

}