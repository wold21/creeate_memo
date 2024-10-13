class RecordInfo {
  final int id;
  final String title;
  final String description;
  final String createAt;
  final String? updateAt;
  final bool isDelete;

  RecordInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.createAt,
    this.updateAt,
    this.isDelete = false,
  });
}
