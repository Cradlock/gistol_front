class AppStrings {
  static const common = CommonStrings();
  static const auth = AuthStrings();
  static const settings = SettingsStrings();
  static const profile = ProfileStrings();
  static const tasks = TasksString();
  static const exams = ExamString();
}

class CommonStrings {
  const CommonStrings();

  static const String _ns = "common.";
  static String _k(String key) => "$_ns$key";

  String get cancel => _k("cancel");
  String get ok => _k("ok");
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
  static String _k(String key) => "$_ns$key";

  String get darkmode => _k("darkmode");
  String get langmode => _k("langmode");
  String get title => _k("title");
}

class ProfileStrings {
  const ProfileStrings();

  static const String _ns = "profile.";
  static String _k(String key) => "$_ns$key";

  String get title => _k("title");
  String get year => _k("year");
  String get group => _k("group");
  String get scores => _k("scores");
  String get settings => _k("settings");
  String get logout => _k("logout");
  String get taskHistory => _k("task_history");
  String get taskHistoryEmpty => _k("task_history_empty");
  String get examHistory => _k("exam_history");
  String get examHistoryEmpty => _k("exam_history_empty");
}

class AuthStrings {
  const AuthStrings();

  static const String _ns = "auth.";
  static String _k(String key) => "$_ns$key";

  String get sign_with_telegram => _k("sign_with_tg");

  String get platform_not_support_error => _k("platform_not_support_error");
  String get user_cancelled => _k("user_cancelled");
  String get script_not_loaded => _k("script_not_loaded");
  String get config_invalid => _k("config_invalid");
  String get internal_error => _k("internal_error");
  String get network_error => _k("network_error");
  String get account_was_deleted => _k("account_was_deleted_please_ask_admin");
  String get invalid_token_error => _k("invalid_token_error");
  String get error_invalid_profile_data => _k("error_invalid_profile_data");
  String get error_session_expired => _k("error_session_expired");
  String get not_confirmed_account => _k("not_confirmed_account");

  String get name_label => _k("name_label");
  String get surname_label => _k("surname_label");
  String get year_label => _k("year_label");
  String get please_select_other_year => _k("please_select_other_year");
  String get complete_data_please => _k("complete_data_please");

  String get comp_name_error => _k("complete_name_error");
  String get comp_surname_error => _k("complete_surname_error");
  String get comp_year_error => _k("complete_year_error");
  String get comp_group_error => _k("complete_group_error");

  String get group_label => _k("group_label");
}

class ExamString {
  const ExamString();

  static const String _ns = "exams.";
  static String _k(String key) => "$_ns$key";

  String get title => _k("title");
  String get empty => _k("empty");
  String get question => _k("question");
  String get yourAnswer => _k("your_answer");
  String get answerPlaceholder => _k("answer_placeholder");
  String get submitted => _k("submitted");
  String get alreadySubmitted => _k("already_submitted");
  String get unavailable => _k("unavailable");
  String get requestError => _k("request_error");
  String get durationMinutes => _k("duration_minutes");
  String get submitConfirm => _k("submit_confirm");
  String get saving => _k("saving");
  String get noAnswer => _k("no_answer");
  String get statusPending => _k("status_pending");
  String get statusReviewed => _k("status_reviewed");
  String get statusExpired => _k("status_expired");
}

class TasksString {
  const TasksString();

  static const String _ns = "tasks.";
  static String _k(String key) => "$_ns$key";

  String get title => _k("title");
  String get empty => _k("empty");
  String get question => _k("question");
  String get yourAnswer => _k("your_answer");
  String get answerPlaceholder => _k("answer_placeholder");
  String get answerSent => _k("answer_sent");
  String get alreadyAnswered => _k("already_answered");
  String get unavailable => _k("unavailable");
  String get requestError => _k("request_error");
  String get critical => _k("urgency_critical");
  String get urgent => _k("urgency_urgent");
  String get soon => _k("urgency_soon");
  String get normal => _k("urgency_normal");
  String get minutesLeft => _k("minutes_left");
  String get hoursLeft => _k("hours_left");
  String get daysLeft => _k("days_left");
  String get statusPending => _k("status_pending");
  String get statusPositive => _k("status_positive");
  String get statusNegative => _k("status_negative");
}
