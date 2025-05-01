import 'package:cat_tinder/data/local/database.dart';
import 'package:cat_tinder/data/models/cat.dart';
import 'package:cat_tinder/data/repositories/liked_cats_repository_impl.dart';
import 'package:drift/drift.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class FakeCatEntryInsertable extends Fake implements Insertable<CatEntry> {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockSimpleSelectStatement extends Mock
    implements SimpleSelectStatement<$CatEntriesTable, CatEntry> {}

class MockInsertStatement extends Mock
    implements InsertStatement<$CatEntriesTable, CatEntry> {}

class MockDeleteStatement extends Mock
    implements DeleteStatement<$CatEntriesTable, CatEntry> {}

class MockSelectableQueryRow extends Mock implements Selectable<QueryRow> {}

class MockQueryRowData extends Fake implements QueryRow {
  final String breedName;

  MockQueryRowData(this.breedName);

  @override
  T read<T>(String columnName) {
    if (columnName == 'breed_name') {
      return breedName as T;
    }
    return null as T;
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCatEntryInsertable());
    registerFallbackValue($CatEntriesTable(MockAppDatabase()));
  });

  group('LikedCatsRepositoryImpl', () {
    late MockAppDatabase mockDb;
    late LikedCatsRepositoryImpl repository;

    setUpAll(() {
      registerFallbackValue(FakeCatEntryInsertable());
      registerFallbackValue($CatEntriesTable(MockAppDatabase()));
      registerFallbackValue(MockSimpleSelectStatement());
    });

    setUp(() {
      mockDb = MockAppDatabase();
      when(() => mockDb.catEntries).thenReturn($CatEntriesTable(mockDb));
      repository = LikedCatsRepositoryImpl(mockDb);
    });

    test('getLikedCats', () async {
      final mockSelectStatement = MockSimpleSelectStatement();
      final catEntry = CatEntry(
        id: '1',
        url: 'http://example.com/cat.jpg',
        breedName: 'Кошка',
        description:
            'Кошка - это домашнее животное, которое является одним из самых популярных питомцев в мире.',
        origin: 'Кошачее царство',
        temperament: 'Добри',
        likedAt: DateTime.now(),
      );
      when(
        () => mockDb.select(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).thenReturn(mockSelectStatement);
      when(() => mockSelectStatement.get()).thenAnswer((_) async => [catEntry]);

      final cats = await repository.getLikedCats();

      expect(cats.length, 1);
      expect(cats.first.id, '1');
      expect(cats.first.breedName, 'Кошка');
    });

    test('addLikedCat', () async {
      final mockInsertStatement = MockInsertStatement();
      when(
        () => mockDb.into(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).thenReturn(mockInsertStatement);
      when(
        () => mockInsertStatement.insertOnConflictUpdate(any()),
      ).thenAnswer((_) async => 1);

      final cat = Cat(
        id: '2',
        url: 'http://example.com/cat2.jpg',
        breedName: 'Крутой Кошка',
        description:
            'Крутой Кошка - это домашнее животное, которое является одним из самых популярных питомцев в мире.',
        origin: 'Краснодарский край',
        temperament: 'Чилловый парень',
      );

      await repository.addLikedCat(cat);

      verify(
        () => mockDb.into(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).called(1);
      verify(() => mockInsertStatement.insertOnConflictUpdate(any())).called(1);
    });

    test('removeLikedCat', () async {
      final mockDeleteStatement = MockDeleteStatement();
      when(
        () => mockDb.delete(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).thenReturn(mockDeleteStatement);
      when(
        () => mockDeleteStatement.where(any()),
      ).thenReturn(mockDeleteStatement);
      when(() => mockDeleteStatement.go()).thenAnswer((_) async => 1);

      await repository.removeLikedCat('1');

      verify(
        () => mockDb.delete(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).called(1);
      verify(() => mockDeleteStatement.where(any())).called(1);
      verify(() => mockDeleteStatement.go()).called(1);
    });

    test('filterByBreed', () async {
      final mockSelectStatement = MockSimpleSelectStatement();
      final catEntry = CatEntry(
        id: '1',
        url: 'http://example.com/cat.jpg',
        breedName: 'Кошка',
        description:
            'Кошка - это домашнее животное, которое является одним из самых популярных питомцев в мире.',
        origin: 'Кошачее царство',
        temperament: 'Добри',
        likedAt: DateTime.now(),
      );
      when(
        () => mockDb.select(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).thenReturn(mockSelectStatement);
      when(
        () => mockSelectStatement.where(any()),
      ).thenReturn(mockSelectStatement);
      when(() => mockSelectStatement.get()).thenAnswer((_) async => [catEntry]);

      final cats = await repository.filterByBreed('Кошка');

      expect(cats.length, 1);
      expect(cats.first.breedName, 'Кошка');
      verify(
        () => mockDb.select(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).called(1);
      verify(() => mockSelectStatement.where(any())).called(1);
      verify(() => mockSelectStatement.get()).called(1);
    });

    test('filterByBreed', () async {
      final mockSelectStatement = MockSimpleSelectStatement();
      final catEntry = CatEntry(
        id: '1',
        url: 'http://example.com/cat.jpg',
        breedName: 'Кошка',
        description:
            'Кошка - это домашнее животное, которое является одним из самых популярных питомцев в мире.',
        origin: 'Кошачее царство',
        temperament: 'Добри',
        likedAt: DateTime.now(),
      );
      when(
        () => mockDb.select(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).thenReturn(mockSelectStatement);
      when(() => mockSelectStatement.get()).thenAnswer((_) async => [catEntry]);

      final cats = await repository.filterByBreed(null);

      expect(cats.length, 1);
      expect(cats.first.breedName, 'Кошка');
      verify(
        () => mockDb.select(any<TableInfo<$CatEntriesTable, CatEntry>>()),
      ).called(1);
      verifyNever(() => mockSelectStatement.where(any()));
      verify(() => mockSelectStatement.get()).called(1);
    });

    test('getBreeds', () async {
      final mockSelectableQueryRow = MockSelectableQueryRow();

      when(
        () => mockDb.customSelect(any(), readsFrom: any(named: 'readsFrom')),
      ).thenReturn(mockSelectableQueryRow);

      final mockQueryResults = [
        MockQueryRowData('Кошка'),
        MockQueryRowData('Крутой Кошка'),
      ];

      when(
        () => mockSelectableQueryRow.get(),
      ).thenAnswer((_) async => mockQueryResults);

      final breeds = await repository.getBreeds();

      expect(breeds.length, 2);
      expect(breeds.contains('Кошка'), isTrue);
      expect(breeds.contains('Крутой Кошка'), isTrue);

      verify(
        () => mockDb.customSelect(any(), readsFrom: any(named: 'readsFrom')),
      ).called(1);
      verify(() => mockSelectableQueryRow.get()).called(1);
    });
  });
}
