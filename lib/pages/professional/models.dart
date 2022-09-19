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
        '{"name": "$name", "description":"$description", "requires":"$requires", "professional_id": "$userId"}';
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

class Business {
  List<String> attrs = ["name", "city"];
  late String? name;
  late String? city;

  Business(
      {this.name,
        this.city});

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

  factory Business.fromJson(Map<dynamic, dynamic> json) {
    Business business = Business();
    for (final dynamic key in json.keys) {
      business.setAttr(key, json[key]);
    }

  return Business(

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
      route: 'update_business_fields',
      jsonData: body,
      token: false,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


  Future<bool> updateField(
      {required String userId, required String key, required String value}) async {
    String body =
        '{"professional_id": "$userId", "$key":"$value"}';
    Response response = await dioHttpPost(
      route: 'update_business_field',
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

