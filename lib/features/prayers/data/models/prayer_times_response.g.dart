// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_times_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrayerTimesResponse _$PrayerTimesResponseFromJson(Map<String, dynamic> json) =>
    PrayerTimesResponse(
      code: _parseIntOrZero(json['code']),
      status: _parseStringOrError(json['status']),
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrayerTimesResponseToJson(
  PrayerTimesResponse instance,
) => <String, dynamic>{
  'code': instance.code,
  'status': instance.status,
  'data': ?instance.data?.toJson(),
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  timings: json['timings'] == null
      ? null
      : Timings.fromJson(json['timings'] as Map<String, dynamic>),
  date: json['date'] == null
      ? null
      : Date.fromJson(json['date'] as Map<String, dynamic>),
  meta: json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'timings': ?instance.timings?.toJson(),
  'date': ?instance.date?.toJson(),
  'meta': ?instance.meta?.toJson(),
};

Timings _$TimingsFromJson(Map<String, dynamic> json) => Timings(
  fajr: _parseString(json['Fajr']),
  sunrise: _parseString(json['Sunrise']),
  dhuhr: _parseString(json['Dhuhr']),
  asr: _parseString(json['Asr']),
  sunset: _parseString(json['Sunset']),
  maghrib: _parseString(json['Maghrib']),
  isha: _parseString(json['Isha']),
  imsak: _parseString(json['Imsak']),
  midnight: _parseString(json['Midnight']),
);

Map<String, dynamic> _$TimingsToJson(Timings instance) => <String, dynamic>{
  'Fajr': ?instance.fajr,
  'Sunrise': ?instance.sunrise,
  'Dhuhr': ?instance.dhuhr,
  'Asr': ?instance.asr,
  'Sunset': ?instance.sunset,
  'Maghrib': ?instance.maghrib,
  'Isha': ?instance.isha,
  'Imsak': ?instance.imsak,
  'Midnight': ?instance.midnight,
};

Date _$DateFromJson(Map<String, dynamic> json) => Date(
  readable: _parseString(json['readable']),
  timestamp: _parseString(json['timestamp']),
  gregorian: json['gregorian'] == null
      ? null
      : GregorianDate.fromJson(json['gregorian'] as Map<String, dynamic>),
  hijri: json['hijri'] == null
      ? null
      : HijriDate.fromJson(json['hijri'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DateToJson(Date instance) => <String, dynamic>{
  'readable': ?instance.readable,
  'timestamp': ?instance.timestamp,
  'gregorian': ?instance.gregorian?.toJson(),
  'hijri': ?instance.hijri?.toJson(),
};

GregorianDate _$GregorianDateFromJson(Map<String, dynamic> json) =>
    GregorianDate(
      date: _parseString(json['date']),
      format: _parseString(json['format']),
      day: _parseString(json['day']),
      weekday: json['weekday'] == null
          ? null
          : Weekday.fromJson(json['weekday'] as Map<String, dynamic>),
      month: json['month'] == null
          ? null
          : Month.fromJson(json['month'] as Map<String, dynamic>),
      year: _parseString(json['year']),
      lunarSighting: _parseBool(json['lunarSighting']),
    );

Map<String, dynamic> _$GregorianDateToJson(GregorianDate instance) =>
    <String, dynamic>{
      'date': ?instance.date,
      'format': ?instance.format,
      'day': ?instance.day,
      'weekday': ?instance.weekday?.toJson(),
      'month': ?instance.month?.toJson(),
      'year': ?instance.year,
      'lunarSighting': ?instance.lunarSighting,
    };

HijriDate _$HijriDateFromJson(Map<String, dynamic> json) => HijriDate(
  date: _parseString(json['date']),
  format: _parseString(json['format']),
  day: _parseString(json['day']),
  weekday: json['weekday'] == null
      ? null
      : Weekday.fromJson(json['weekday'] as Map<String, dynamic>),
  month: json['month'] == null
      ? null
      : Month.fromJson(json['month'] as Map<String, dynamic>),
  year: _parseString(json['year']),
);

Map<String, dynamic> _$HijriDateToJson(HijriDate instance) => <String, dynamic>{
  'date': ?instance.date,
  'format': ?instance.format,
  'day': ?instance.day,
  'weekday': ?instance.weekday?.toJson(),
  'month': ?instance.month?.toJson(),
  'year': ?instance.year,
};

Weekday _$WeekdayFromJson(Map<String, dynamic> json) =>
    Weekday(en: _parseString(json['en']), ar: _parseString(json['ar']));

Map<String, dynamic> _$WeekdayToJson(Weekday instance) => <String, dynamic>{
  'en': ?instance.en,
  'ar': ?instance.ar,
};

Month _$MonthFromJson(Map<String, dynamic> json) => Month(
  number: _parseInt(json['number']),
  en: _parseString(json['en']),
  ar: _parseString(json['ar']),
);

Map<String, dynamic> _$MonthToJson(Month instance) => <String, dynamic>{
  'number': ?instance.number,
  'en': ?instance.en,
  'ar': ?instance.ar,
};

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  timezone: _parseString(json['timezone']),
  latitude: _parseDouble(json['latitude']),
  longitude: _parseDouble(json['longitude']),
  lunarSighting: _parseBool(json['lunarSighting']),
  method: json['method'] == null
      ? null
      : Method.fromJson(json['method'] as Map<String, dynamic>),
  params: json['params'] == null
      ? null
      : Params.fromJson(json['params'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'timezone': ?instance.timezone,
  'latitude': ?instance.latitude,
  'longitude': ?instance.longitude,
  'lunarSighting': ?instance.lunarSighting,
  'method': ?instance.method?.toJson(),
  'params': ?instance.params?.toJson(),
};

Method _$MethodFromJson(Map<String, dynamic> json) => Method(
  id: _parseInt(json['id']),
  name: _parseString(json['name']),
  params: _parseString(json['params']),
);

Map<String, dynamic> _$MethodToJson(Method instance) => <String, dynamic>{
  'id': ?instance.id,
  'name': ?instance.name,
  'params': ?instance.params,
};

Params _$ParamsFromJson(Map<String, dynamic> json) =>
    Params(fajr: _parseDouble(json['Fajr']), isha: _parseDouble(json['Isha']));

Map<String, dynamic> _$ParamsToJson(Params instance) => <String, dynamic>{
  'Fajr': ?instance.fajr,
  'Isha': ?instance.isha,
};
