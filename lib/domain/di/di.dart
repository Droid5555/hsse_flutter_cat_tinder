import 'package:get_it/get_it.dart';
import 'package:cat_tinder/data/repositories/liked_cats_repository_impl.dart';
import 'package:cat_tinder/domain/repositories/liked_cats_repository.dart';
import 'package:cat_tinder/presentation/blocs/liked_cats_cubit.dart';
import 'package:cat_tinder/data/local/database.dart';

import 'package:cat_tinder/data/local/dislike_storage.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Database
  final database = AppDatabase();
  locator.registerSingleton<AppDatabase>(database);

  // Repositories
  locator.registerSingleton<LikedCatsRepository>(
    LikedCatsRepositoryImpl(database),
  );
  locator.registerSingleton<DislikeCounterStorage>(DislikeCounterStorage());

  // Cubits
  locator.registerFactory(() => LikedCatsCubit(locator<LikedCatsRepository>()));
}
