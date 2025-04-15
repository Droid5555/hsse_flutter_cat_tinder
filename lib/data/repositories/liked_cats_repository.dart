import '../models/cat.dart';

abstract class LikedCatsRepository {
  List<Cat> getLikedCats();

  void addLikedCat(Cat cat);

  void removeLikedCat(String id);

  List<Cat> filterByBreed(String? breed);

  List<String> getBreeds();
}

class LikedCatsRepositoryImpl implements LikedCatsRepository {
  final List<Cat> _likedCats = [];

  @override
  List<Cat> getLikedCats() => _likedCats;

  @override
  void addLikedCat(Cat cat) {
    _likedCats.add(cat.copyWith(likedAt: DateTime.now()));
  }

  @override
  void removeLikedCat(String id) {
    _likedCats.removeWhere((cat) => cat.id == id);
  }

  @override
  List<Cat> filterByBreed(String? breed) {
    if (breed == null || breed.isEmpty) return _likedCats;
    return _likedCats
        .where((cat) => cat.breedName.toLowerCase() == breed.toLowerCase())
        .toList();
  }

  @override
  List<String> getBreeds() {
    return _likedCats.map((cat) => cat.breedName).toSet().toList();
  }
}
