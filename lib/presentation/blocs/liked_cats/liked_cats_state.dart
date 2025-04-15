import '../../../data/models/cat.dart';

class LikedCatsState {
  final List<Cat> cats;
  final List<String> breeds;
  final String? selectedBreed;

  const LikedCatsState({
    this.cats = const [],
    this.breeds = const [],
    this.selectedBreed,
  });

  LikedCatsState copyWith({
    List<Cat>? cats,
    List<String>? breeds,
    String? selectedBreed,
  }) {
    return LikedCatsState(
      cats: cats ?? this.cats,
      breeds: breeds ?? this.breeds,
      selectedBreed: selectedBreed,
    );
  }
}
