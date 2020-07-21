class Note {
  final int userId;
  final int id;
  final String title;

  Note({this.userId, this.id, this.title});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
