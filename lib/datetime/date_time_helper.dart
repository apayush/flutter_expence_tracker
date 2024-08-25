//convert datetime object to a string yyyymmdd

String convertDateTimeToString(DateTime datetime) {
   //year in the format -> yyyy
   String year = datetime.year.toString();

   //month in the format -> mm
   String month = datetime.month.toString();
   if(month.length == 1) {
    month = '0$month';
   }

   //day in the format -> dd
   String day = datetime.day.toString();
   if(day.length == 1) {
    day = '0$day';
   }

   //final format -> yyyymmdd
   String yyyymmdd = year + month + day;

   return yyyymmdd;
}