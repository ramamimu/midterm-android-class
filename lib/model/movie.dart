const String tableMoviesName = 'movies';

class MovieFields {
  static final List<String> values = [
    id,
    title,
    imageURL,
    description,
    time,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String imageURL = 'imageURL';
  static const String description = 'description';
  static const String time = 'time';
}

class Movie {
  final int? id;
  final String title;
  final String imageURL;
  final String description;
  final DateTime createdTime;

  const Movie(
      {this.id,
      required this.title,
      required this.imageURL,
      required this.description,
      required this.createdTime});

  Movie copy({
    int? id,
    String? title,
    String? imageURL,
    String? description,
    DateTime? createdTime,
  }) =>
      Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        imageURL: imageURL ?? this.imageURL,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
        id: json[MovieFields.id] as int?,
        title: json[MovieFields.title] as String,
        imageURL: json[MovieFields.imageURL] as String,
        description: json[MovieFields.description] as String,
        createdTime: DateTime.parse(json[MovieFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        MovieFields.id: id,
        MovieFields.title: title,
        MovieFields.imageURL: imageURL,
        MovieFields.description: description,
        MovieFields.time: createdTime.toIso8601String(),
      };
}
