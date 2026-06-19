import 'package:json_annotation/json_annotation.dart';

part 'prayer_times_response.g.dart';

// TODO: Verify JSON field casing
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class PrayerTimesResponse {
  @JsonKey(fromJson: _parseIntOrZero)
  final int code;

  @JsonKey(fromJson: _parseStringOrError)
  final String status;
  final Data? data;

  PrayerTimesResponse({required this.code, required this.status, this.data});

  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimesResponseToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Data {
  final Timings? timings;
  final Date? date;
  final Meta? meta;

  Data({this.timings, this.date, this.meta});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

// TODO: Verify JSON field casing
@JsonSerializable(includeIfNull: false)
class Timings {
  @JsonKey(name: 'Fajr', fromJson: _parseString)
  final String? fajr;

  @JsonKey(name: 'Sunrise', fromJson: _parseString)
  final String? sunrise;

  @JsonKey(name: 'Dhuhr', fromJson: _parseString)
  final String? dhuhr;

  @JsonKey(name: 'Asr', fromJson: _parseString)
  final String? asr;

  @JsonKey(name: 'Sunset', fromJson: _parseString)
  final String? sunset;

  @JsonKey(name: 'Maghrib', fromJson: _parseString)
  final String? maghrib;

  @JsonKey(name: 'Isha', fromJson: _parseString)
  final String? isha;

  @JsonKey(name: 'Imsak', fromJson: _parseString)
  final String? imsak;

  @JsonKey(name: 'Midnight', fromJson: _parseString)
  final String? midnight;

  Timings({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
  });

  factory Timings.fromJson(Map<String, dynamic> json) =>
      _$TimingsFromJson(json);

  Map<String, dynamic> toJson() => _$TimingsToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Date {
  @JsonKey(fromJson: _parseString)
  final String? readable;

  @JsonKey(fromJson: _parseString)
  final String? timestamp;
  final GregorianDate? gregorian;
  final HijriDate? hijri;

  Date({this.readable, this.timestamp, this.gregorian, this.hijri});

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);

  Map<String, dynamic> toJson() => _$DateToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class GregorianDate {
  @JsonKey(fromJson: _parseString)
  final String? date;

  @JsonKey(fromJson: _parseString)
  final String? format;

  @JsonKey(fromJson: _parseString)
  final String? day;
  final Weekday? weekday;
  final Month? month;

  @JsonKey(fromJson: _parseString)
  final String? year;

  @JsonKey(fromJson: _parseBool)
  final bool? lunarSighting;

  GregorianDate({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.lunarSighting,
  });

  factory GregorianDate.fromJson(Map<String, dynamic> json) =>
      _$GregorianDateFromJson(json);

  Map<String, dynamic> toJson() => _$GregorianDateToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class HijriDate {
  @JsonKey(fromJson: _parseString)
  final String? date;

  @JsonKey(fromJson: _parseString)
  final String? format;

  @JsonKey(fromJson: _parseString)
  final String? day;
  final Weekday? weekday;
  final Month? month;

  @JsonKey(fromJson: _parseString)
  final String? year;

  HijriDate({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
  });

  factory HijriDate.fromJson(Map<String, dynamic> json) =>
      _$HijriDateFromJson(json);

  Map<String, dynamic> toJson() => _$HijriDateToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Weekday {
  @JsonKey(fromJson: _parseString)
  final String? en;

  @JsonKey(fromJson: _parseString)
  final String? ar;

  Weekday({this.en, this.ar});

  factory Weekday.fromJson(Map<String, dynamic> json) =>
      _$WeekdayFromJson(json);

  Map<String, dynamic> toJson() => _$WeekdayToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Month {
  @JsonKey(fromJson: _parseInt)
  final int? number;

  @JsonKey(fromJson: _parseString)
  final String? en;

  @JsonKey(fromJson: _parseString)
  final String? ar;

  Month({this.number, this.en, this.ar});

  factory Month.fromJson(Map<String, dynamic> json) => _$MonthFromJson(json);

  Map<String, dynamic> toJson() => _$MonthToJson(this);
}

/// Safely parse a value to boolean
bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is String) {
    final lowerValue = value.toLowerCase();
    if (lowerValue == 'true') return true;
    if (lowerValue == 'false') return false;
    // Try parsing as integer string
    if (value == '1') return true;
    if (value == '0') return false;
  }
  if (value is int) {
    return value != 0;
  }
  // If none of the above work, return null instead of crashing
  return null;
}

/// Safely parse a value to string
String? _parseString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  // Convert non-null values to string representation
  return value.toString();
}

/// Safely parse a value to integer
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    try {
      return int.parse(value);
    } catch (e) {
      // Try parsing double string and convert to int
      try {
        return double.parse(value).round();
      } catch (e2) {
        return null;
      }
    }
  }
  if (value is double) return value.round();
  // If none of the above work, return null instead of crashing
  return null;
}

/// Safely parse a value to double
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }
  // If none of the above work, return null instead of crashing
  return null;
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Meta {
  @JsonKey(fromJson: _parseString)
  final String? timezone;

  @JsonKey(fromJson: _parseDouble)
  final double? latitude;

  @JsonKey(fromJson: _parseDouble)
  final double? longitude;

  @JsonKey(fromJson: _parseBool)
  final bool? lunarSighting;
  final Method? method;
  final Params? params;

  Meta({
    this.timezone,
    this.latitude,
    this.longitude,
    this.lunarSighting,
    this.method,
    this.params,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Method {
  @JsonKey(fromJson: _parseInt)
  final int? id;

  @JsonKey(fromJson: _parseString)
  final String? name;

  @JsonKey(fromJson: _parseString)
  final String? params;

  Method({this.id, this.name, this.params});

  factory Method.fromJson(Map<String, dynamic> json) => _$MethodFromJson(json);

  Map<String, dynamic> toJson() => _$MethodToJson(this);
}

@JsonSerializable(includeIfNull: false)
class Params {
  @JsonKey(name: 'Fajr', fromJson: _parseDouble)
  final double? fajr;

  @JsonKey(name: 'Isha', fromJson: _parseDouble)
  final double? isha;

  Params({this.fajr, this.isha});

  factory Params.fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);

  Map<String, dynamic> toJson() => _$ParamsToJson(this);
}

int _parseIntOrZero(dynamic value) => _parseInt(value) ?? 0;

String _parseStringOrError(dynamic value) => _parseString(value) ?? 'ERROR';
