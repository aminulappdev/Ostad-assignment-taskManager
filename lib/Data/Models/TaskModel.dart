
class TaskData {
  String? sId;
  String? title;
  String? description;
  String? status;
  String? email;
  String? createdDate;

  TaskData(
      {this.sId,
      this.title,
      this.description,
      this.status,
      this.email,
      this.createdDate});

  TaskData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    email = json['email'];
    createdDate = json['createdDate'];
  }

  
}