abstract final class ApiEndPoints{
  static String baseUrl = 'https://example.com';
  static String apiUrl = '/connector/api';

  //#region used by http

  ///auth
  static String loginUrl ='$baseUrl/oauth/token';
  static String getUser = '$baseUrl$apiUrl/user/loggedin';


  ///attendance
  static String checkIn ='$baseUrl$apiUrl/clock-in';
  static String checkOut ='$baseUrl$apiUrl/clock-out';
  static String getAttendance ='$baseUrl$apiUrl/get-attendance/';


  ///contact
  static String contact = '$baseUrl$apiUrl/contactapi';
  static String getContact = '$contact?type=customer&per_page=500';
  static String addContact = '$contact?type=customer';
  //contact payment
  static String customerDue = '$contact/';
  static String addContactPayment = '$contact-payment';

  //#endregion

  //#region used by Dio

  ///Notifications
  static String allNotifications = '$apiUrl/notifications';

  ///brands
  static String allBrands = '$apiUrl/brand';

  ///Purchases
  static String purchases = '$apiUrl/purchases';
  //#endregion
}