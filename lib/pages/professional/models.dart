import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';

class JobOffer {
  late String name;
  late String description;
  late String requires;

  JobOffer(
      {required this.requires,
        required this.description,
        required this.name});

  void setAttr(String name, value) {
    switch (name) {
      case "name":
        {
          name = value;
        }
        break;

      case "description":
        {
          description = value;
        }
        break;

      case "requires":
        {
          requires = value;
        }
        break;
    }
  }

  factory JobOffer.fromJson(Map<dynamic, dynamic> json) => JobOffer(
    name: json['name'],
    description: json['description'],
    requires: json['requires'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'requires': requires,
  };

  Future<bool> addJobOffer(
      {required String userId}) async {
    String body =
        '{"name": "$name", "description":"$description", "requires":"$requires", "user_id": "$userId"}';
    Response response = await dioHttpPost(
      route: 'add_job_offer',
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


}
