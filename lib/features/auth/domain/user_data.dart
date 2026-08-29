
class Group{
  int id;
  String title;
  final DateTime createdDate;
  int year;
  
  Group({required this.year,required this.id,required this.title,required this.createdDate});
  
  factory Group.converter(dynamic json) {
    return Group(
      id: json['id'] as int,
      title: json['title'] as String,
      year: json['year'] as int,
      createdDate: DateTime.parse(json['created_date'] as String) 
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
