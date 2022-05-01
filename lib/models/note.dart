class Note {
  int id;
  String title;
  String description;

  Note(this.id, this.title, this.description);
  Note.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        description = map["description"];

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
      };
}
