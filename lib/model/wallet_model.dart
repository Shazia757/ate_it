class WalletResponse {
  bool? status;
  String? message;
  WalletModel? data;

  WalletResponse({
    required this.status,
    required this.data,
    this.message,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      data: json['data'] != null
          ? WalletModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data};
  }
}

class WalletModel {
  String? balance;
  String? updatedAt;

  WalletModel({this.balance, this.updatedAt});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(balance: json['balance'], updatedAt: json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance, 'updated_at': updatedAt};
  }
}

class TopupResponse {
  bool? status;
  String? message;
  List<TopupModel>? data;

  TopupResponse({
    required this.status,
    required this.data,
    this.message,
  });

  factory TopupResponse.fromJson(Map<String, dynamic> json) {
    return TopupResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TopupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data};
  }
}

class TopupModel {
  String? id;
  String? amount;
  String? transactionType;
  String? status;
  DateTime? createdAt;

  TopupModel(
      {this.id,
      this.amount,
      this.createdAt,
      this.status,
      this.transactionType});

  factory TopupModel.fromJson(Map<String, dynamic> json) {
    return TopupModel(
        amount: json['amount'],
        createdAt: DateTime.parse(json['created_at']),
        id: json['id'],
        status: json['status'],
        transactionType: json['transaction_type']);
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'created_at': createdAt.toString(),
      'id': id,
      'status': status,
      'transaction_type': transactionType
    };
  }
}
