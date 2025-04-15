import 'package:get_it/get_it.dart';
import 'package:cat_tinder/data/repositories/liked_cats_repository_impl.dart';
import 'package:cat_tinder/domain/repositories/liked_cats_repository.dart';
import '../../../presentation/blocs/liked_cats/liked_cats_cubit.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Repositories
  locator.registerSingleton<LikedCatsRepository>(LikedCatsRepositoryImpl());

  // Cubits
  locator.registerFactory(() => LikedCatsCubit(locator<LikedCatsRepository>()));
}
