import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_tinder/data/models/cat.dart';
import 'package:cat_tinder/domain/repositories/liked_cats_repository.dart';
import 'package:cat_tinder/data/local/dislike_storage.dart';
import 'package:cat_tinder/domain/di/di.dart';
import 'liked_cats_state.dart';

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final LikedCatsRepository repository;

  LikedCatsCubit(this.repository) : super(const LikedCatsState());

  Future<void> setInitialCats(List<Cat> cats) async {
    emit(LikedCatsState(cats: cats));
  }

  Future<void> loadLikedCats() async {
    final allCats = await repository.getLikedCats();
    final breeds = await repository.getBreeds();
    emit(
      state.copyWith(
        allCats: allCats,
        cats: allCats,
        breeds: breeds,
        selectedBreed: null,
      ),
    );
  }

  Future<void> addLikedCat(Cat cat) async {
    await repository.addLikedCat(cat);
    final allCats = await repository.getLikedCats();
    final breeds = await repository.getBreeds();

    final filteredCats =
        state.selectedBreed != null
            ? await repository.filterByBreed(state.selectedBreed)
            : allCats;

    emit(state.copyWith(allCats: allCats, cats: filteredCats, breeds: breeds));
  }

  Future<void> dislikeCat() async {
    final dislikeStorage = locator<DislikeCounterStorage>();
    await dislikeStorage.incrementDislikeCount();
  }

  Future<void> removeLikedCat(String id, {String? selectedBreed}) async {
    await repository.removeLikedCat(id);
    final allCats = await repository.getLikedCats();
    final breeds = await repository.getBreeds();

    String? updatedSelectedBreed = selectedBreed;
    if (selectedBreed != null && !breeds.contains(selectedBreed)) {
      updatedSelectedBreed = null;
    }

    final filteredCats =
        updatedSelectedBreed != null
            ? await repository.filterByBreed(updatedSelectedBreed)
            : allCats;

    emit(
      state.copyWith(
        allCats: allCats,
        cats: filteredCats,
        breeds: breeds,
        selectedBreed: updatedSelectedBreed,
      ),
    );
  }

  Future<void> filterByBreed(String? breed) async {
    final filteredCats = await repository.filterByBreed(breed);
    final breeds = await repository.getBreeds();

    emit(
      state.copyWith(cats: filteredCats, breeds: breeds, selectedBreed: breed),
    );
  }
}
