/// Class holding the card utilities while validating
class DOBUtils {

  /// Method for validating the card DATE
  /// It returns a string value
  static String validateDate(String value) {
    if (value.isEmpty) {
      return 'Enter Date of Birth';
    }

    /// Integer variable holding date of birth year
    int year;

    /// Integer variable holding the date of birth month
    int month;

    /// Integer variable holding date of birth year
    int day;

    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(RegExp(r'(\/)'))) {
      var split = value.split(RegExp(r'(\/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      day = int.parse(split[0]);
      month = int.parse(split[1]);
      year = int.parse(split[2]);

    }
    else if('/'.allMatches(value).length == 1 || '\\'.allMatches(value).length == 1){
      // Only the day and month was entered
      day = int.parse(value.substring(0, (value.length)));
      month = int.parse(value.substring(2, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }
    else { // Only the day was entered
      day = int.parse(value.substring(0, (value.length)));
      month = -1; // Lets use an invalid month intentionally
      year = -1; // Lets use an invalid year intentionally
    }

    // Number Days in each month of a normal year
    List<int> daysMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    // Number Days in each month of a leap year
    List<int> daysMonthL = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Month is invalid';
    }

    if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0){
      if ((day < 1) || (day > daysMonthL[month - 1])) {
        // A valid day is between 1 and [daysMonthL[month]]
        return 'Day is invalid';
      }
    }
    else{
      if ((day < 1) || (day > daysMonth[month - 1])) {
        // A valid day is between 1 and [daysMonth[month]]
        return 'Day is invalid';
      }
    }

    if ((year < 1000) || (year > 3099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Year is invalid';
    }

    return '';
  }


  /// Method for validating the card DATE if it has expired
  /// It returns a boolean value
  static bool hasDateExpired(int month, int year, int day) {
    return !(day == null || month == null || year == null) && isNotExpired(year, month, day);
  }

  /// Method for validating the card DATE if it has not expired
  /// It returns a boolean value
  static bool isNotExpired(int year, int month, int day) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month) && !hasDayPassed(day, year, month);
  }

  /// Method for get Date of Birth
  /// It returns a List of Integer
  static List<int> getDateOfBirth(String value) {
    var split = value.split(RegExp(r'(\/)'));
    return [int.parse(split[0]), int.parse(split[1]), int.parse(split[2])];
  }

  /// Method for get Date of Birth
  /// It returns a List of Integer
  static String combineDateOfBirth(DateTime value) {
    if(value == null) return '';
    String month = value.month.toString();
    if(month.length != 2){
      month = '0$month';
    }
    List<String> date = [value.day.toString(), month, value.year.toString()];
    return date.join('/');
  }

  /// Method to check if day has passed from today's day by comparing
  /// today's day to [day]
  /// It returns a boolean value
  static bool hasDayPassed(int year, int month, int day) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        year == now.year && month == now.month && (day < now.day + 1);
  }

  /// Method to check if month has passed from today's month by comparing
  /// today's month to [month]
  /// It returns a boolean value
  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        year == now.year && (month < now.month + 1);
  }

  /// Method to check if year has passed from today's year by comparing
  /// today's year to [year]
  /// It returns a boolean value
  static bool hasYearPassed(int year) {
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return year < now.year;
  }

}