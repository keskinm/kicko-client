import 'package:kicko/dio.dart';
import 'package:dio/dio.dart';

class Candidate {
  List<String> attrs = ["name", "city"];
  late String? name;
  late String? city;

  Candidate({this.name, this.city});

  void setAttr(String name, value) {
    switch (name) {
      case "name":
        {
          name = value;
        }
        break;

      case "city":
        {
          city = value;
        }
        break;
    }
  }

  String? getAttr(String key) {
    switch (key) {
      case "name":
        {
          return name;
        }

      case "city":
        {
          return city;
        }
    }
    return null;
  }

  factory Candidate.fromJson(Map<dynamic, dynamic> json) {
    Candidate candidate = Candidate();
    for (final dynamic key in json.keys) {
      candidate.setAttr(key, json[key]);
    }

    return Candidate(
      name: json['name'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'city': city,
      };

  Future<bool> updateFields({required String userId}) async {
    String body = '{"professional_id": "$userId"';
    for (final attr in attrs) {
      dynamic attrValue = getAttr(attr);
      if (getAttr(attr) != null) {
        body = body + ', "$attr":"$attrValue"';
      }
    }
    body = body + '}';

    Response response = await dioHttpPost(
      route: 'update_candidate_fields',
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
