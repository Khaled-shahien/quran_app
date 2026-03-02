class KhatmaModel {
  final String id;
  final String startMode; // 'بداية المصحف', 'جزء مخصص'
  final int startJuz;
  final int durationDays;
  final String amountType; // 'جزء', 'ربع'
  final String amountValue;
  final DateTime startDate;

  // Progress tracking
  final int currentJuz;
  final int completedDays;
  final bool isCompleted;

  KhatmaModel({
    required this.id,
    required this.startMode,
    required this.startJuz,
    required this.durationDays,
    required this.amountType,
    required this.amountValue,
    required this.startDate,
    this.currentJuz = 1,
    this.completedDays = 0,
    this.isCompleted = false,
  });

  factory KhatmaModel.fromJson(Map<String, dynamic> json) {
    return KhatmaModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      startMode: json['startMode'] ?? 'بداية المصحف',
      startJuz: json['startJuz'] ?? 1,
      durationDays: json['durationDays'] ?? 30,
      amountType: json['amountType'] ?? 'جزء',
      amountValue: json['amountValue'] ?? '1 جزء',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      currentJuz: json['currentJuz'] ?? 1,
      completedDays: json['completedDays'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startMode': startMode,
      'startJuz': startJuz,
      'durationDays': durationDays,
      'amountType': amountType,
      'amountValue': amountValue,
      'startDate': startDate.toIso8601String(),
      'currentJuz': currentJuz,
      'completedDays': completedDays,
      'isCompleted': isCompleted,
    };
  }

  KhatmaModel copyWith({
    String? id,
    String? startMode,
    int? startJuz,
    int? durationDays,
    String? amountType,
    String? amountValue,
    DateTime? startDate,
    int? currentJuz,
    int? completedDays,
    bool? isCompleted,
  }) {
    return KhatmaModel(
      id: id ?? this.id,
      startMode: startMode ?? this.startMode,
      startJuz: startJuz ?? this.startJuz,
      durationDays: durationDays ?? this.durationDays,
      amountType: amountType ?? this.amountType,
      amountValue: amountValue ?? this.amountValue,
      startDate: startDate ?? this.startDate,
      currentJuz: currentJuz ?? this.currentJuz,
      completedDays: completedDays ?? this.completedDays,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
