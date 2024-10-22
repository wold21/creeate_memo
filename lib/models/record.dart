class RecordInfo {
  final int id;
  final String title;
  final String description;
  final String createAt;
  final String? updateAt;
  final bool isDelete;
  final bool isFavorite;
  final int replyCount;

  RecordInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.createAt,
    this.updateAt,
    this.isDelete = false,
    this.isFavorite = false,
    required this.replyCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createAt': createAt,
      'updateAt': updateAt,
      'isDelete': isDelete ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0,
      'replyCount': replyCount,
    };
  }
}
