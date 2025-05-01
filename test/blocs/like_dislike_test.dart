import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_tinder/data/models/cat.dart';
import 'package:cat_tinder/domain/repositories/liked_cats_repository.dart';
import 'package:cat_tinder/data/local/dislike_storage.dart';
import 'package:cat_tinder/presentation/blocs/liked_cats_cubit.dart';

class MockLikedCatsRepository extends Mock implements LikedCatsRepository {}

class MockDislikeCounterStorage extends Mock implements DislikeCounterStorage {}

final sl = GetIt.instance;

void main() {
  late LikedCatsCubit cubit;
  late MockLikedCatsRepository mockRepository;
  late MockDislikeCounterStorage mockDislikeStorage;

  setUp(() {
    mockRepository = MockLikedCatsRepository();
    mockDislikeStorage = MockDislikeCounterStorage();

    if (sl.isRegistered<DislikeCounterStorage>()) {
      sl.resetLazySingleton<DislikeCounterStorage>();
    }
    sl.registerSingleton<DislikeCounterStorage>(mockDislikeStorage);

    cubit = LikedCatsCubit(mockRepository);
  });

  tearDown(() {
    sl.reset();
  });

  group('LikedCatsCubit', () {
    final testCat = Cat(
      id: '1',
      url: 'https://example.com/cat.jpg',
      breedName: 'Кошка',
      temperament: 'Добри',
      origin: 'Кошковое королевство',
      description:
          'Кошка - это домашнее животное, которое является одним из самых популярных питомцев в мире.',
    );

    test('Лайк', () async {
      when(() => mockRepository.addLikedCat(testCat)).thenAnswer((_) async {});
      when(
        () => mockRepository.getLikedCats(),
      ).thenAnswer((_) async => [testCat]);
      when(() => mockRepository.getBreeds()).thenAnswer((_) async => ['Кошка']);

      await cubit.addLikedCat(testCat);

      expect(cubit.state.allCats, equals([testCat]));
      expect(cubit.state.cats, equals([testCat]));
      expect(cubit.state.breeds, equals(['Кошка']));
    });

    test('Дизлайк', () async {
      when(
        () => mockDislikeStorage.incrementDislikeCount(),
      ).thenAnswer((_) async {});

      await cubit.dislikeCat();

      verify(() => mockDislikeStorage.incrementDislikeCount()).called(1);
    });
  });
}
