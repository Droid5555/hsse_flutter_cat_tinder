import 'package:cat_tinder/data/models/cat.dart';
import 'package:cat_tinder/data/local/database.dart';
import 'package:cat_tinder/domain/repositories/liked_cats_repository.dart';
import 'package:drift/drift.dart';

class LikedCatsRepositoryImpl implements LikedCatsRepository {
  final AppDatabase db;

  LikedCatsRepositoryImpl(this.db);

  Cat _mapEntryToCat(CatEntry entry) {
    return Cat(
      id: entry.id,
      url: entry.url,
      breedName: entry.breedName,
      description: entry.description,
      origin: entry.origin,
      temperament: entry.temperament,
      likedAt: entry.likedAt,
    );
  }

  CatEntriesCompanion _mapCatToEntry(Cat cat) {
    return CatEntriesCompanion(
      id: Value(cat.id),
      url: Value(cat.url),
      breedName: Value(cat.breedName),
      description: Value(cat.description),
      origin: Value(cat.origin),
      temperament: Value(cat.temperament),
      likedAt: Value(cat.likedAt ?? DateTime.now()),
    );
  }

  @override
  Future<List<Cat>> getLikedCats() async {
    final entries = await db.select(db.catEntries).get();
    return entries.map(_mapEntryToCat).toList();
  }

  @override
  Future<void> addLikedCat(Cat cat) async {
    await db.into(db.catEntries).insertOnConflictUpdate(_mapCatToEntry(cat));
  }

  @override
  Future<void> removeLikedCat(String id) async {
    await (db.delete(db.catEntries)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<Cat>> filterByBreed(String? breed) async {
    final query =
        breed == null || breed.isEmpty
            ? db.select(db.catEntries)
            : (db.select(db.catEntries)
              ..where((tbl) => tbl.breedName.equals(breed)));
    final entries = await query.get();
    return entries.map(_mapEntryToCat).toList();
  }

  @override
  Future<List<String>> getBreeds() async {
    final rows =
        await db
            .customSelect(
              'SELECT DISTINCT breed_name FROM cat_entries',
              readsFrom: {db.catEntries},
            )
            .get();
    return rows.map((row) => row.read<String>('breed_name')).toList();
  }
}
