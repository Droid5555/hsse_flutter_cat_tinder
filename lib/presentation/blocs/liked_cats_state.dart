import 'package:cat_tinder/data/models/cat.dart';
import 'package:equatable/equatable.dart';

class LikedCatsState extends Equatable {
  final List<Cat> allCats;
  final List<Cat> cats;
  final List<String> breeds;
  final String? selectedBreed;

  const LikedCatsState({
    this.allCats = const [],
    this.cats = const [],
    this.breeds = const [],
    this.selectedBreed,
  });

  @override
  List<Object?> get props => [allCats, cats, breeds, selectedBreed];

  LikedCatsState copyWith({
    List<Cat>? allCats,
    List<Cat>? cats,
    List<String>? breeds,
    String? selectedBreed,
  }) {
    return LikedCatsState(
      allCats: allCats ?? this.allCats,
      cats: cats ?? this.cats,
      breeds: breeds ?? this.breeds,
      selectedBreed: selectedBreed,
    );
  }
}
