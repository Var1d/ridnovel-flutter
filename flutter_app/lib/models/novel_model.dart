// Farid Dhiya Fairuz - 247006111058 - B

class Novel {
  final int id;
  final String title;
  final String author;
  final String genre;
  final int chapters;
  final double rating;
  final String? createdAt;

  Novel({required this.id, required this.title, required this.author,
      required this.genre, required this.chapters, required this.rating, this.createdAt});

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      genre: json['genre'] ?? '',
      chapters: json['chapters'] is int ? json['chapters'] : int.tryParse(json['chapters'].toString()) ?? 0,
      rating: json['rating'] is double ? json['rating'] : double.tryParse(json['rating'].toString()) ?? 0.0,
      createdAt: json['created_at'],
    );
  }
}
