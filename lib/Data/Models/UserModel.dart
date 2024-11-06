
class UserModel {
  String? sId;
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;
  String? createdDate;

  String? get fullname {
       return '${firstName ?? ''} ${lastName ?? ''}';
  }

  UserModel(
      {this.sId,
      this.email,
      this.firstName,
      this.lastName,
      this.mobile,
      this.photo,
      this.createdDate});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    photo = json['photo'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['mobile'] = this.mobile;
    data['photo'] = this.photo;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
