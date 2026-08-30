
import 'package:app_front/core/core.dart';

class Group{
  int id;
  String title;
  int year;
  
  Group({
  required this.year,
  required this.id,
  required this.title
  });
  
  factory Group.converter(dynamic json) {
    return Group(
      id: json['id'] as int,
      title: json['title'] as String,
      year: json['year'] as int,
    );
  }
}

class GroupResponse {
  final int total;
  final List<Group> groups;

  GroupResponse({
    required this.total,
    required this.groups,
  }); 

  factory GroupResponse.converter(dynamic data) {
    final json = data as Map<String, dynamic>;

    return GroupResponse(
      total: json['total'] as int? ?? 0,
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((item) => Group.converter(item))
          .toList(),
    );
  }
}


class YearsResponse {
  final List<int> years;
  
  const YearsResponse({required this.years});

  factory YearsResponse.converter(dynamic json ){
    return YearsResponse( 
      years:(json['years'] as List<dynamic>).cast<int>()
    );
  }

}



class UserCompleteRequest implements ToJsonable{
  final String name;
  final String surname;
  final int groupId;
  final int year;

  const UserCompleteRequest({
    required this.name,
    required this.surname,
    required this.groupId,
    required this.year
  });
  
  @override
  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "surname": surname,
      "group_id": groupId,
      "year": year
    };
  }


}
