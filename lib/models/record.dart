class RecordInfo {
  final int id;
  final String title;
  final String description;
  final String createAt; // String으로 유지
  final String? updateAt; // String으로 유지
  final int isDelete;
  final int isFavorite;
  final int replyCount;

  RecordInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.createAt,
    this.updateAt,
    this.isDelete = 0,
    this.isFavorite = 0,
    this.replyCount = 0,
  });

  RecordInfo.insert({
    required this.title,
    required this.description,
  })  : id = 0,
        createAt = DateTime.now().toIso8601String(),
        updateAt = null,
        isDelete = 0,
        isFavorite = 0,
        replyCount = 0;

  RecordInfo.update({
    required this.id,
    required this.title,
    required this.description,
    required this.createAt,
  })  : updateAt = DateTime.now().toIso8601String(),
        isDelete = 0,
        isFavorite = 0,
        replyCount = 0;

  factory RecordInfo.fromMap(Map<String, dynamic> map) {
    return RecordInfo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createAt: map['createAt'] ?? DateTime.now().toIso8601String(),
      updateAt: map['updateAt'],
      isDelete: map['isDelete'],
      isFavorite: map['isFavorite'],
      replyCount: map['replyCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createAt': createAt,
      'updateAt': updateAt,
      'isDelete': isDelete,
      'isFavorite': isFavorite,
      'replyCount': replyCount,
    };
  }

  RecordInfo copyWith({
    int? id,
    String? title,
    String? description,
    String? createAt,
    String? updateAt,
    int? isDelete,
    int? isFavorite,
    int? replyCount,
  }) {
    return RecordInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      isDelete: isDelete ?? this.isDelete,
      isFavorite: isFavorite ?? this.isFavorite,
      replyCount: replyCount ?? this.replyCount,
    );
  }
}
