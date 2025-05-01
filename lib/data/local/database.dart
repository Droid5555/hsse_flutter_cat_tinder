import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class CatEntries extends Table {
  TextColumn get id => text()();

  TextColumn get url => text()();

  TextColumn get breedName => text()();

  TextColumn get description => text()();

  TextColumn get origin => text()();

  TextColumn get temperament => text()();

  DateTimeColumn get likedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CatEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.connect(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/cat_tinder.sqlite');
    return NativeDatabase(file);
  });
}
