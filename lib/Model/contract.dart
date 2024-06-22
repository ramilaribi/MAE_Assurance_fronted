import 'package:perper/Model/user.dart';

class Contract {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String coverageDetails;
  final double prime;
  final User user;
  String status;

  Contract({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.coverageDetails,
    required this.prime,
    required this.user,
    required this.status,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    print('Parsing Contract: $json');
    return Contract(
      id: json['_id'] ?? '',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now(),
      coverageDetails: json['coverageDetails'] ?? '',
      prime: (json['prime'] as num?)?.toDouble() ?? 0.0,
      user: User.fromJson(json['user'] ?? {}),
      status: json['status'] ?? 'Pending',
    );
  }
}
