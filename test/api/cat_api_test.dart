import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_tinder/data/services/cat_service.dart';
import 'package:cat_tinder/data/models/cat.dart';

class MockCatService extends Mock implements CatService {}

void main() {
  late MockCatService mockCatService;

  setUp(() {
    mockCatService = MockCatService();
  });

  group('CatService', () {
    final testCats = [
      Cat(
        id: '1',
        url: 'https://example.com/cat1.jpg',
        breedName: 'Кошко 1',
        temperament: 'Добри',
        origin: 'Кошковое королевство',
        description: 'Кот - это домашнее животное.',
      ),
      Cat(
        id: '2',
        url: 'https://example.com/cat2.jpg',
        breedName: 'Кошко 2',
        temperament: 'Злой',
        origin: 'Краснодарский край',
        description: 'Кот - это домашнее животное.',
      ),
    ];

    test('fetchRandomCats basic', () async {
      when(
        () => mockCatService.fetchRandomCats(2),
      ).thenAnswer((_) async => testCats);

      final result = await mockCatService.fetchRandomCats(2);

      expect(result, equals(testCats));
      expect(result.length, 2);
      verify(() => mockCatService.fetchRandomCats(2)).called(1);
    });

    test('fetchRandomCats exception', () async {
      when(
        () => mockCatService.fetchRandomCats(any()),
      ).thenThrow(Exception('Не удалось загрузить котиков'));

      expect(() => mockCatService.fetchRandomCats(1), throwsException);
    });
  });
}
