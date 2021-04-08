class Reviews {
  final String author;
  final String content;
  final String created_at;
  final String id;
  final String url;
  final Map author_details;

  Reviews(this.author, this.id, this.content, this.created_at, this.url,
      this.author_details);

  Reviews.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"],
        author = json["author"],
        content = json["content"],
        created_at = json["created_at"],
        author_details = json["author_details"],
        url = json["url"];
}
