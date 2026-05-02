import 'dart:convert';

class HolidayModel {
  final String date;
  final String name;
  final bool isSubstitute;

  const HolidayModel({
    required this.date,
    required this.name,
    required this.isSubstitute,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      date: json['date'] as String,
      name: json['name'] as String,
      isSubstitute: json['isSubstitute'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'name': name,
        'isSubstitute': isSubstitute,
      };
}

class HolidayResponse {
  final int year;
  final int month;
  final List<HolidayModel> holidays;

  const HolidayResponse({
    required this.year,
    required this.month,
    required this.holidays,
  });

  factory HolidayResponse.fromJson(Map<String, dynamic> json) {
    return HolidayResponse(
      year: json['year'] as int,
      month: json['month'] as int,
      holidays: (json['holidays'] as List<dynamic>)
          .map((e) => HolidayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJsonString() => jsonEncode({
        'year': year,
        'month': month,
        'holidays': holidays.map((h) => h.toJson()).toList(),
      });
}
