class Cat {
  final String id;
  final String url;
  final String breedName;
  final String description;
  final String origin;
  final String temperament;
  final DateTime? likedAt;

  Cat({
    required this.id,
    required this.url,
    required this.breedName,
    required this.description,
    required this.origin,
    required this.temperament,
    this.likedAt,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    final breed =
        json['breeds'] != null && json['breeds'].isNotEmpty
            ? json['breeds'][0]
            : null;
    return Cat(
      id: json['id'],
      url: json['url'],
      breedName: breed != null ? breed['name'] : 'Unknown',
      description:
          breed != null ? breed['description'] : 'No description available',
      origin: breed != null ? breed['origin'] : 'Unknown',
      temperament: breed != null ? breed['temperament'] : 'Unknown',
    );
  }

  Cat copyWith({DateTime? likedAt}) {
    return Cat(
      id: id,
      url: url,
      breedName: breedName,
      description: description,
      origin: origin,
      temperament: temperament,
      likedAt: likedAt ?? this.likedAt,
    );
  }
}
