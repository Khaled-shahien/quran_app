// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AyahModel _$AyahModelFromJson(Map<String, dynamic> json) => AyahModel(
  number: (json['number'] as num?)?.toInt() ?? 0,
  text: json['text'] as String? ?? '',
  numberInSurah: (json['numberInSurah'] as num?)?.toInt() ?? 0,
  juz: (json['juz'] as num?)?.toInt() ?? 0,
  manzil: (json['manzil'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 0,
  ruku: (json['ruku'] as num?)?.toInt() ?? 0,
  hizbQuarter: (json['hizbQuarter'] as num?)?.toInt() ?? 0,
  sajda: json['sajda'] == null
      ? false
      : AyahModel._sajdaFromJson(json['sajda']),
);

Map<String, dynamic> _$AyahModelToJson(AyahModel instance) => <String, dynamic>{
  'number': instance.number,
  'text': instance.text,
  'numberInSurah': instance.numberInSurah,
  'juz': instance.juz,
  'manzil': instance.manzil,
  'page': instance.page,
  'ruku': instance.ruku,
  'hizbQuarter': instance.hizbQuarter,
  'sajda': AyahModel._sajdaToJson(instance.sajda),
};
