class AddCommentRequest {
  final String text;

  AddCommentRequest({required this.text});

  Map<String, dynamic> toJson() {
    return {
      "text": text,
    };
  }
}


class CommentModel {
  final String id;
  final String text;
  final String userName;
  final String? parentId;

  CommentModel({
    required this.id,
    required this.text,
    required this.userName,
    this.parentId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      text: json['text'],
      userName: json['user']?['name'] ?? 'User',
      parentId: json['parentId'],
    );
  }
}
