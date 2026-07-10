class PostModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
    userId: json['userId'] is int
        ? json['userId'] as int
        : int.tryParse('${json['userId']}') ?? 0,
    title: json['title']?.toString() ?? '',
    body: json['body']?.toString() ?? '',
  );
}
