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
}
