class PrayerTimesResponse {
  final int code;
  final String status;
  final Data? data;

  PrayerTimesResponse({required this.code, required this.status, this.data});

  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) {
    return PrayerTimesResponse(
      code: _parseInt(json['code']) ?? 0,
      status: _parseString(json['status']) ?? 'ERROR',
      data: json['data'] != null
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class Data {
  final Timings? timings;
  final Date? date;
  final Meta? meta;

  Data({this.timings, this.date, this.meta});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      timings: json['timings'] != null
          ? Timings.fromJson(json['timings'] as Map<String, dynamic>)
          : null,
      date: json['date'] != null
          ? Date.fromJson(json['date'] as Map<String, dynamic>)
          : null,
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (timings != null) 'timings': timings!.toJson(),
      if (date != null) 'date': date!.toJson(),
      if (meta != null) 'meta': meta!.toJson(),
    };
  }
}

class Timings {
  final String? fajr;
  final String? sunrise;
  final String? dhuhr;
  final String? asr;
  final String? sunset;
  final String? maghrib;
  final String? isha;
  final String? imsak;
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

  factory Timings.fromJson(Map<String, dynamic> json) {
    return Timings(
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
  }

  Map<String, dynamic> toJson() {
    return {
      if (fajr != null) 'Fajr': fajr,
      if (sunrise != null) 'Sunrise': sunrise,
      if (dhuhr != null) 'Dhuhr': dhuhr,
      if (asr != null) 'Asr': asr,
      if (sunset != null) 'Sunset': sunset,
      if (maghrib != null) 'Maghrib': maghrib,
      if (isha != null) 'Isha': isha,
      if (imsak != null) 'Imsak': imsak,
      if (midnight != null) 'Midnight': midnight,
    };
  }
}

class Date {
  final String? readable;
  final String? timestamp;
  final GregorianDate? gregorian;
  final HijriDate? hijri;

  Date({this.readable, this.timestamp, this.gregorian, this.hijri});

  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      readable: _parseString(json['readable']),
      timestamp: _parseString(json['timestamp']),
      gregorian: json['gregorian'] != null
          ? GregorianDate.fromJson(json['gregorian'] as Map<String, dynamic>)
          : null,
      hijri: json['hijri'] != null
          ? HijriDate.fromJson(json['hijri'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (readable != null) 'readable': readable,
      if (timestamp != null) 'timestamp': timestamp,
      if (gregorian != null) 'gregorian': gregorian!.toJson(),
      if (hijri != null) 'hijri': hijri!.toJson(),
    };
  }
}

class GregorianDate {
  final String? date;
  final String? format;
  final String? day;
  final Weekday? weekday;
  final Month? month;
  final String? year;
  final bool? lunarSighting; // Added lunarSighting field from gregorian.date

  GregorianDate({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.lunarSighting,
  });

  factory GregorianDate.fromJson(Map<String, dynamic> json) {
    return GregorianDate(
      date: _parseString(json['date']),
      format: _parseString(json['format']),
      day: _parseString(json['day']),
      weekday: json['weekday'] != null
          ? Weekday.fromJson(json['weekday'] as Map<String, dynamic>)
          : null,
      month: json['month'] != null
          ? Month.fromJson(json['month'] as Map<String, dynamic>)
          : null,
      year: _parseString(json['year']),
      lunarSighting: _parseBool(
        json['lunarSighting'],
      ), // Parse lunarSighting from gregorian.date
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (date != null) 'date': date,
      if (format != null) 'format': format,
      if (day != null) 'day': day,
      if (weekday != null) 'weekday': weekday!.toJson(),
      if (month != null) 'month': month!.toJson(),
      if (year != null) 'year': year,
      if (lunarSighting != null) 'lunarSighting': lunarSighting,
    };
  }
}

class HijriDate {
  final String? date;
  final String? format;
  final String? day;
  final Weekday? weekday;
  final Month? month;
  final String? year;

  HijriDate({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
  });

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      date: _parseString(json['date']),
      format: _parseString(json['format']),
      day: _parseString(json['day']),
      weekday: json['weekday'] != null
          ? Weekday.fromJson(json['weekday'] as Map<String, dynamic>)
          : null,
      month: json['month'] != null
          ? Month.fromJson(json['month'] as Map<String, dynamic>)
          : null,
      year: _parseString(json['year']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (date != null) 'date': date,
      if (format != null) 'format': format,
      if (day != null) 'day': day,
      if (weekday != null) 'weekday': weekday!.toJson(),
      if (month != null) 'month': month!.toJson(),
      if (year != null) 'year': year,
    };
  }
}

class Weekday {
  final String? en;
  final String? ar;

  Weekday({this.en, this.ar});

  factory Weekday.fromJson(Map<String, dynamic> json) {
    return Weekday(en: _parseString(json['en']), ar: _parseString(json['ar']));
  }

  Map<String, dynamic> toJson() {
    return {if (en != null) 'en': en, if (ar != null) 'ar': ar};
  }
}

class Month {
  final int? number;
  final String? en;
  final String? ar;

  Month({this.number, this.en, this.ar});

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      number: _parseInt(json['number']),
      en: _parseString(json['en']),
      ar: _parseString(json['ar']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (number != null) 'number': number,
      if (en != null) 'en': en,
      if (ar != null) 'ar': ar,
    };
  }
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

class Meta {
  final String? timezone;
  final double? latitude;
  final double? longitude;
  final bool? lunarSighting; // Added lunarSighting field
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

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      timezone: _parseString(json['timezone']),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      lunarSighting: _parseBool(
        json['lunarSighting'],
      ), // Safe parsing for lunarSighting
      method: json['method'] != null
          ? Method.fromJson(json['method'] as Map<String, dynamic>)
          : null,
      params: json['params'] != null
          ? Params.fromJson(json['params'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (timezone != null) 'timezone': timezone,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (lunarSighting != null) 'lunarSighting': lunarSighting,
      if (method != null) 'method': method!.toJson(),
      if (params != null) 'params': params!.toJson(),
    };
  }
}

class Method {
  final int? id;
  final String? name;
  final String? params;

  Method({this.id, this.name, this.params});

  factory Method.fromJson(Map<String, dynamic> json) {
    return Method(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      params: _parseString(json['params']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (params != null) 'params': params,
    };
  }
}

class Params {
  final double? fajr;
  final double? isha;

  Params({this.fajr, this.isha});

  factory Params.fromJson(Map<String, dynamic> json) {
    return Params(
      fajr: _parseDouble(json['Fajr']),
      isha: _parseDouble(json['Isha']),
    );
  }

  Map<String, dynamic> toJson() {
    return {if (fajr != null) 'Fajr': fajr, if (isha != null) 'Isha': isha};
  }
}
