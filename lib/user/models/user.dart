class User {
  late String id;
  late String username;
  late String email;
  late String token;

  User({this.username = '', this.email = '', this.token = '', this.id = ''});

  void setId(value) {
    id = value;
  }

  void setUsername(value) {
    username = value;
  }

  void setEmail(value) {
    email = value;
  }

  void setToken(value) {
    token = value;
  }

  Map<String, dynamic> setPropsMap() {
    return {
      'id': setId,
      'username': setUsername,
      'email': setEmail,
      'token': setToken
    };
  }

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'id': id,
      };

  void setParameters(Map<String, dynamic> json) {
    Map<String, dynamic> map = setPropsMap();

    for (final dynamic key in json.keys) {
      if (map.containsKey(key)) {
        Function func = map[key];
        func(json[key]);
      }
    }
  }
}
