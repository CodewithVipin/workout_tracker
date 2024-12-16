// return todays date as yyyymmdd e.g. 20241210
String todayDateYYYYMMDD() {
  // today
  var dateTimeObject = DateTime.now();

  // year in format of yyyy
  String year = dateTimeObject.year.toString();

  //month in format of mm

  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //day in format of dd

  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

// final format
  String yyymmdd = year + month + day;
  return yyymmdd;
}

// converts string yyyymmdd to DateTime object
DateTime createDateTimeObject(String yyymmdd) {
  int yyyy = int.parse(yyymmdd.substring(0, 4));
  int mm = int.parse(yyymmdd.substring(4, 6));
  int dd = int.parse(yyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

// converts DateTime object to a string yyyymmdd

String convertDateTimeToYYYYMMDD(DateTime dateTime) {
  //year in format of yyyy

  String year = dateTime.year.toString();

  //month in format of mm

  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //year in format of dd

  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

// final format

  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
