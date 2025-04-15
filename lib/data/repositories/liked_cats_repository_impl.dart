import 'package:cat_tinder/data/models/cat.dart';
import 'package:cat_tinder/domain/repositories/liked_cats_repository.dart';

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
