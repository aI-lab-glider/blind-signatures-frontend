class Poll {
  final int id;
  final DateTime expirationDate;
  final String title;
  final String description;

  Poll({
    required this.id,
    required this.expirationDate,
    required this.title,
    required this.description
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'],
      expirationDate: DateTime.parse(json['expiration_date']),
      title: json['title'],
      description: json['description']
    );
  }

}