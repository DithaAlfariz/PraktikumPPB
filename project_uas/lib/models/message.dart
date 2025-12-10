class Message {
  final String text;
  final String time;
  final bool isSender;

  Message({
    required this.text,
    required this.time,
    required this.isSender,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'time': time,
      'isSender': isSender,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] as String,
      time: json['time'] as String,
      isSender: json['isSender'] as bool,
    );
  }
}

class Rating {
  final String userName;
  final String userInitial;
  final int rating;
  final String comment;

  Rating({
    required this.userName,
    required this.userInitial,
    required this.rating,
    required this.comment,
  });
}