import 'package:cat_tinder/data/models/cat.dart';

abstract class LikedCatsRepository {
  List<Cat> getLikedCats();

  void addLikedCat(Cat cat);

  void removeLikedCat(String id);

  List<Cat> filterByBreed(String? breed);

  List<String> getBreeds();
}
