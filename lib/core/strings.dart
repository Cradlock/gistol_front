


class AppStrings {
  static const common = CommonStrings();
  static const auth = AuthStrings();
  static const settings = SettingsStrings();
}

class CommonStrings {
  const CommonStrings();

  static const String _ns = "common.";
  
  // Вспомогательный метод для склейки
  static String _k(String key) => "$_ns$key";

  // Теперь писать одно удовольствие:
  String get cancel => _k("cancel");
  String get yes => _k("yes");
  String get exit => _k("exit"); 
  String get save => _k("save"); 
  String get create => _k("create");
  String get errorBlankInput => _k("error_blank_input");
  String get submit => _k("submit");
  String get retry => _k("retry");
  String get from => _k("from");
  String get to => _k("to");

  String get error_no_internet => _k("error_no_internet");
  String get error_server_error => _k("error_server_error"); 
  String get error_timeout => _k("error_timeout");
}

class SettingsStrings {
  const SettingsStrings();

  static const String _ns = "settings.";
  
  // Вспомогательный метод для склейки
  static String _k(String key) => "$_ns$key";
  
  String get darkmode => _k("darkmode");
  String get langmode => _k("langmode");
 
}
class AuthStrings {
  const AuthStrings();

  static const String _ns = "auth.";
  static String _k(String key) => "$_ns$key";

  // Ошибки авторизации Telegram
  String get platform_not_support_error => _k("platform_not_support_error");
  String get user_cancelled => _k("user_cancelled");
  String get script_not_loaded => _k("script_not_loaded");
  String get config_invalid => _k("config_invalid");
  String get internal_error => _k("internal_error");
  String get network_error => _k("network_error");
  
  String get invalid_token_error => _k("invalid_token_error");
  String get error_invalid_profile_data => _k("error_invalid_profile_data");
  String get error_session_expired => _k("error_session_expired");
  String get not_confirmed_account => _k("not_confirmed_account");
  // Поля формы
  String get name_label => _k("name_label");
  String get surname_label => _k("surname_label");
  String get year_label => _k("year_label"); // Исправлена опечатка yesr_label
  String get please_select_other_year => _k("please_select_other_year");
  String get complete_data_please => _k("complete_data_please"); 

  // Валидация полей
  String get comp_name_error => _k("complete_name_error");
  String get comp_surname_error => _k("complete_surname_error");
  String get comp_year_error => _k("complete_year_error");
  String get comp_group_error => _k("complete_group_error");
  
  String get group_label => _k("group_label");
}

