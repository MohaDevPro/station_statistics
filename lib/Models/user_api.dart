class UserAPI {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? passWord;
  String? type;
  String? deviceId;
  bool? active;

  UserAPI({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.passWord,
    this.type,
    this.deviceId,
    this.active,
  });

  UserAPI.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    passWord = json['passWord'];
    type = json['type'];
    deviceId = json['deviceId'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    data['passWord'] = this.passWord;
    data['type'] = this.type;
    data['deviceId'] = this.deviceId;
    data['active'] = this.active ?? true;
    return data;
  }
}
