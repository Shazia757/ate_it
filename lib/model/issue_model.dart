class IssueModel {
  final int? id;
  final String? title;
  final String? description;
  final String? status;
  final DateTime? createdAt;

  IssueModel({
    this.id,
    this.title,
    this.description,
    this.status = 'Pending',
    this.createdAt,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'] ?? 'Pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

class IssueResponse {
  bool? status;
  String? message;
  IssueModel? data;

  IssueResponse({this.status, this.message, this.data});

  factory IssueResponse.fromJson(Map<String, dynamic> json) {
    return IssueResponse(
      data: json['data'] != null
          ? IssueModel.fromJson(json['data'] as Map<String, dynamic>)
          : IssueModel(),
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data};
  }
}

class GetIssueResponse {
  bool? status;
  String? message;
  IssueData? data;

  GetIssueResponse({
    this.status,
    this.message,
    this.data,
  });
  factory GetIssueResponse.fromJson(Map<String, dynamic> json) {
    return GetIssueResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? IssueData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class IssueData {
  int? count;
  String? next;
  String? previous;
  List<IssueStatus>? results;

  IssueData({this.count, this.next, this.previous, this.results});

  factory IssueData.fromJson(Map<String, dynamic> json) {
    return IssueData(
      count: json['count'] as int?,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => IssueStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results?.map((e) => e.toJson()).toList(),
    };
  }
}

class IssueStatus {
  int? id;
  String? title;
  String? description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  IssueStatus(
      {this.id,
      this.description,
      this.createdAt,
      this.status,
      this.updatedAt,
      this.title});

  factory IssueStatus.fromJson(Map<String, dynamic> json) {
    return IssueStatus(
        id: json['id'] as int?,
        status: json['status'],
        createdAt: DateTime.parse(
          json['created_at'],
        ),
        updatedAt: DateTime.parse(
          json['updated_at'],
        ),
        description: json['description'],
        title: json['title']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }
}

