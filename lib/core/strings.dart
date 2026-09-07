


class AppStrings {
  static const common = CommonStrings();
  static const auth = AuthStrings();
  static const groups = GroupStrings();
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

  String get from => _k("from");
  String get to => _k("to");
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
  
  // Вспомогательный метод для склейки
  static String _k(String key) => "$_ns$key";
  
  String get name_label => _k("name_label");
  String get surname_label => _k("surname_label");
  String get year_label => _k("yesr_label");
  String get please_select_other_year => _k("please_select_other_year");
  
  String get complete_data_please => _k("complete_data_please"); 

  String get comp_name_error => _k("complete_name_error");
  String get comp_surname_error => _k("complete_surname_error");
  String get comp_year_error => _k("complete_year_error");
  String get comp_group_error => _k("complete_group_error");
}

class GroupStrings {
  const GroupStrings();

  static const String _ns = "groups.";
  
  // Вспомогательный метод для склейки
  static String _k(String key) => "$_ns$key";
  String get title => _k("title");
  String get filters => _k("filters");
  String get sort => _k("sort");
  String get resetSort => _k("reset_sort");
  String get resetFilters => _k("reset_filters");
  
  String get minToMax => _k("min_to_max");
  String get maxToMin => _k("max_to_min");
  
  String get sortOrder => _k("sort_order");
  String get sortField => _k("sort_field");

  // Поля для сортировки
  String get sortFieldDate => _k("sort.field_date");
  String get sortFieldStudents => _k("sort.field_students");
  String get sortFieldTitle => _k("sort.field_title");
  
  String get addPlaceholderTitle => _k("add_placeholder_title");
  String get addPlaceholderCourse => _k("add_placeholder_course");
  
  String get filterCourseRangeLabel => _k("filterCourseRangeLabel");
  String get filterDateRangeLabel => _k("filterDateRangeLabel");
  String get filterStudentsCountRangeLabel => _k("filterStudentsCountRangeLabel");
  
  

}




