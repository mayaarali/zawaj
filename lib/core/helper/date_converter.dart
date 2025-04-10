import 'package:intl/intl.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }
  static String dateTimeInDays(String dateTime) {
    DateTime time = DateTime.parse(dateTime);
    return DateTime.now().difference(time.add(const Duration(days: 1))).inDays.toString();
  }

  static String convertToAgo(String input){
    DateTime time = DateTime.parse(input);
    Duration diff = DateTime.now().difference(time);

    if(diff.inDays >= 1){
      return '${diff.inDays} day ago';
    } else if(diff.inHours >= 1){
      return '${diff.inHours} hour ago';
    } else if(diff.inMinutes >= 1){
      return '${diff.inMinutes} minute ago';
    } else if (diff.inSeconds >= 1){
      return '${diff.inSeconds} second ago';
    } else {
      return 'just now';
    }
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('h:mm a | d-MMM-yyyy ').format(dateTime.toLocal());
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('hh:mm aa').format(isoStringToLocalDate(dateTime));
  }
  static String isoStringToLocalAMPM(String dateTime) {
    return DateFormat('a').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime.toUtc());
  }

  static String convertTimeToTime(String time) {
    return DateFormat('hh:mm a').format(DateFormat('hh:mm:ss').parse(time));
  }
}
