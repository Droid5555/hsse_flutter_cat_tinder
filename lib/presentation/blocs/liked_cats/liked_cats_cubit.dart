import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cat.dart';
import '../../../data/repositories/liked_cats_repository.dart';
import 'liked_cats_state.dart';

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final LikedCatsRepository repository;

  LikedCatsCubit(this.repository) : super(const LikedCatsState());

  void loadLikedCats() {
    emit(state.copyWith(cats: repository.getLikedCats(), breeds: repository.getBreeds()));
  }

  void addLikedCat(Cat cat) {
    repository.addLikedCat(cat);
    emit(state.copyWith(cats: repository.getLikedCats(), breeds: repository.getBreeds()));
  }

  void removeLikedCat(String id) {
    repository.removeLikedCat(id);
    emit(state.copyWith(cats: repository.getLikedCats(), breeds: repository.getBreeds()));
  }

  void filterByBreed(String? breed) {
    emit(state.copyWith(
      cats: repository.filterByBreed(breed),
      selectedBreed: breed,
      breeds: repository.getBreeds(),
    ));
  }
}