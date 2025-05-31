class Name {
  final String common;
  final String official;

  Name({required this.common, required this.official});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      common: json['common'] ?? '',
      official: json['official'] ?? '',
    );
  }
}