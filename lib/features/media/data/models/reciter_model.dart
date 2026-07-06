import '../../domain/entities/reciter.dart';

class ReciterModel extends Reciter {
  const ReciterModel({
    required super.id,
    required super.name,
    required super.serverUrl,
    required super.surahList,
    required super.moshafName,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    final moshafs = (json['moshaf'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
    if (moshafs.isEmpty) {
      throw const FormatException('Reciter has no moshaf data');
    }

    final moshaf = moshafs.firstWhere(
      (data) =>
          (data['server'] as String? ?? '').isNotEmpty &&
          (data['surah_list'] as String? ?? '').isNotEmpty,
      orElse: () => moshafs.first,
    );

    return ReciterModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      serverUrl: moshaf['server'] as String? ?? '',
      surahList: moshaf['surah_list'] as String? ?? '',
      moshafName: moshaf['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'moshaf': <Map<String, dynamic>>[
        <String, dynamic>{
          'name': moshafName,
          'server': serverUrl,
          'surah_list': surahList,
        },
      ],
    };
  }
}
