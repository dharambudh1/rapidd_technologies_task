// ignore_for_file: always_specify_types

class Task {
  const Task({
    this.id,
    this.title,
    this.description,
    this.ownerEmail,
    this.sharedWith,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"] as String?,
      title: json["title"] as String?,
      description: json["description"] as String?,
      ownerEmail: json["ownerEmail"] as String?,
      sharedWith: (json["sharedWith"] as List<dynamic>?)?.map((e) {
        return e.toString();
      }).toList(),
    );
  }

  final String? id;
  final String? title;
  final String? description;
  final String? ownerEmail;
  final List<dynamic>? sharedWith;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      "id": id,
      "title": title,
      "description": description,
      "ownerEmail": ownerEmail,
      "sharedWith": sharedWith,
    };

    return data;
  }
}
