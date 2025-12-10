class User {
  final int? id;
  final String username;
  final String password;
  final String email;
  final String joinDate;
  final int courses;
  final int reviews;
  final double rating;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.joinDate,
    this.courses = 0,
    this.reviews = 0,
    this.rating = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'joinDate': joinDate,
      'courses': courses,
      'reviews': reviews,
      'rating': rating,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'] ?? '',
      joinDate: map['joinDate'] ?? '',
      courses: map['courses'] ?? 0,
      reviews: map['reviews'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }
}