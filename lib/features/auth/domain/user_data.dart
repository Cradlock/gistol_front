
class Year{
  final int id;
  final String title;

  Year({required this.id,required this.title});
  
  factory Year.fromJson(Map<String,dynamic> json){
    return Year(
      id: json['id'] as int, 
      title: json['title'] as String
    );
  }

}

class Group{
  int id;
  String title;
  
  Group({required this.id,required this.title});
  
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}


