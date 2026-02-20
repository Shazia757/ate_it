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
  String? message;
  String? transactionId;
  String? amount;
  String? status;

  WalletModel({this.amount, this.message, this.status, this.transactionId});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
        status: json['status'],
        message: json['message'],
        transactionId: json['transaction_id'],
        amount: json['amount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'transaction_id': transactionId,
      'amount': amount,
    };
  }
}
