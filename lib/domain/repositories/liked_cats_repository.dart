import 'package:cat_tinder/data/models/cat.dart';

abstract class LikedCatsRepository {
  Future<List<Cat>> getLikedCats();

  Future<void> addLikedCat(Cat cat);

  Future<void> removeLikedCat(String id);

  Future<List<Cat>> filterByBreed(String? breed);

  Future<List<String>> getBreeds();
}
