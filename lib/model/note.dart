class Note {
  String title;
  String description;
  bool isFavorite;
  DateTime creationDate; // Add creationDate property

  Note({
    required this.title,
    required this.description,
    this.isFavorite = false,
    required this.creationDate, // Update constructor
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isFavorite': isFavorite,
      'creationDate':
          creationDate.toIso8601String(), // Serialize DateTime to string
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      description: json['description'],
      isFavorite: json['isFavorite'] ?? false,
      creationDate:
          DateTime.parse(json['creationDate']), // Parse string to DateTime
    );
  }
}
