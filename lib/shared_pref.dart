import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._ctor();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._ctor();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //isloggedin
  static void setIsLoggedIn({required bool status}) {
    _prefs.setBool('isLoggedIn', status);
  }

  static dynamic getIsLoggedIn() {
    return _prefs.getBool("isLoggedIn") ?? false;
  }

  //superadmin token

  static void setTokensuperadmin({required String apiKey}) {
    _prefs.setString("token", apiKey);
  }

  static String getTokensuperadmin() {
    return _prefs.getString("token") ?? "";
  }

  //customer token

  static void setTokencustomer({required String apiKey}) {
    _prefs.setString("token", apiKey);
  }

  static String getTokencustomer() {
    return _prefs.getString("token") ?? "";
  }

  //deliveryboy token

  static void setTokendeliveryboy({required String apiKey}) {
    _prefs.setString("token", apiKey);
  }

  static String getTokendeliveryboy() {
    return _prefs.getString("token") ?? "";
  }

  //superadmin id

  static void setIDsuperadmin({required String id}) {
    _prefs.setString("superadmin_id", id);
  }

  static String getIDsuperadmin() {
    return _prefs.getString("superadmin_id") ?? "";
  }

  //customer id

  static void setIDcustomer({required String id}) {
    _prefs.setString("customer_id", id);
  }

  static String getIDcustomer() {
    return _prefs.getString("customer_id") ?? "";
  }

  //deliveryboy id

  static void setIDdeliveryboy({required String id}) {
    _prefs.setString("deliveryboy_id", id);
  }

  static String getIDdeliveryboy() {
    return _prefs.getString("deliveryboy_id") ?? "";
  }

  //set role

  static void setRole({required String rolename}) {
    _prefs.setString("role", rolename);
  }

  static String getRole() {
    return _prefs.getString("role") ?? "";
  }

  //superadmin username and password
  static void setsuperadminusername({required String username}) {
    _prefs.setString("superadmin_username", username);
  }

  static String getsuperadminusername() {
    return _prefs.getString("superadmin_username") ?? "";
  }

  static void setsuperadminpassword({required String password}) {
    _prefs.setString("superadmin_password", password);
  }

  static String getsuperadminpassword() {
    return _prefs.getString("superadmin_password") ?? "";
  }

  //customer mobno and password
  static void setcustomermobno({required String mobno}) {
    _prefs.setString("customer_mobno", mobno);
  }

  static String getcustomermobno() {
    return _prefs.getString("customer_mobno") ?? "";
  }

  static void setcustomerpassword({required String password}) {
    _prefs.setString("customer_password", password);
  }

  static String getcustomerpassword() {
    return _prefs.getString("customer_password") ?? "";
  }

  // deliveryboy username and password
  static void setdeliveryboymobno({required String mobno}) {
    _prefs.setString("deliveryboy_mobno", mobno);
  }

  static String getdeliveryboymobno() {
    return _prefs.getString("deliveryboy_mobno") ?? "";
  }

  static void setdeliveryboypassword({required String password}) {
    _prefs.setString("deliveryboy_password", password);
  }

  static String getdeliveryboypassword() {
    return _prefs.getString("deliveryboy_password") ?? "";
  }

  //customer address
  static void setcustomeraddress({required String address}) {
    _prefs.setString("customer_address", address);
  }

  static String getcustomeraddress() {
    return _prefs.getString("customer_address") ?? "";
  }

  static void setcustomerwalletbalance({required String walletbalance}) {
    _prefs.setString("walletbalance", walletbalance);
  }

  static String getcustomerwalletbalance() {
    return _prefs.getString("walletbalance") ?? "";
  }

  //clean role
  static void clearRole() {
    _prefs.remove("role");
  }
}
