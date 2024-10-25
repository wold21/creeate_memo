class ContributionInfo {
  final int id;
  final int year;
  final int month;
  final int day;
  final int count;
  final DateTime lastUpdateAt;

  ContributionInfo({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.count,
    required this.lastUpdateAt,
  });

  factory ContributionInfo.fromMap(Map<String, Object?> map) {
    return ContributionInfo(
      id: map['id'] as int,
      year: int.parse(map['year'] as String),
      month: int.parse(map['month'] as String),
      day: int.parse(map['day'] as String),
      count: map['count'] as int,
      lastUpdateAt: DateTime.parse(map['lastUpdateAt'] as String),
    );
  }
}
