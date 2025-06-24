import '../../domain/entities/issue.dart';

class IssueModel extends Issue {
  IssueModel({
    required super.id,
    required super.title,
    required super.number,
    required super.user,
    required super.state,
    required super.isPR,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      number: json['number'],
      user: json['user']['login'],
      state: json['state'],
      isPR: json.containsKey('pull_request'),
    );
  }

  Issue toEntity() => Issue(
        id: id,
        title: title,
        number: number,
        user: user,
        state: state,
        isPR: isPR,
      );
}
