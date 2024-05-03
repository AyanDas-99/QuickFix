// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Detail {
  final String? title;
  final String? description;

  Detail({
    this.title,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return '$title : $description';
  }
}
