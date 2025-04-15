import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cat.dart';
import '../../../data/repositories/liked_cats_repository.dart';
import 'liked_cats_state.dart';

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final LikedCatsRepository repository;

  LikedCatsCubit(this.repository) : super(const LikedCatsState());

  void loadLikedCats() {
    final cats = repository.getLikedCats();
    final breeds = repository.getBreeds();
    emit(state.copyWith(cats: cats, breeds: breeds, selectedBreed: null));
  }

  void addLikedCat(Cat cat) {
    repository.addLikedCat(cat);
    final cats = repository.getLikedCats();
    final breeds = repository.getBreeds();
    emit(
      state.copyWith(
        cats:
            state.selectedBreed != null
                ? repository.filterByBreed(state.selectedBreed)
                : cats,
        breeds: breeds,
      ),
    );
  }

  void removeLikedCat(String id, {String? selectedBreed}) {
    repository.removeLikedCat(id);
    final newCats = repository.getLikedCats();
    final newBreeds = repository.getBreeds();

    String? updatedSelectedBreed = selectedBreed;
    if (selectedBreed != null && !newBreeds.contains(selectedBreed)) {
      updatedSelectedBreed = null;
    }

    emit(
      state.copyWith(
        cats:
            updatedSelectedBreed != null
                ? repository.filterByBreed(updatedSelectedBreed)
                : newCats,
        breeds: newBreeds,
        selectedBreed: updatedSelectedBreed,
      ),
    );
  }

  void filterByBreed(String? breed) {
    final newCats = repository.filterByBreed(breed);
    final newBreeds = repository.getBreeds();
    emit(
      state.copyWith(
        cats: newCats,
        breeds: newBreeds,
        selectedBreed: newBreeds.contains(breed) ? breed : null,
      ),
    );
  }
}
