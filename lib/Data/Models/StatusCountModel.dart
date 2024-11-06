class StatusCountModel {
  String? status;
  List<Data>? statusCountData;

  StatusCountModel({this.status, this.statusCountData});

  StatusCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      statusCountData = <Data>[];
      json['data'].forEach((v) {
        statusCountData!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? sId;
  int? sum;

  Data({this.sId, this.sum});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }
}
