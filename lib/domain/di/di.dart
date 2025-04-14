import 'package:get_it/get_it.dart';
import '../../../data/repositories/liked_cats_repository.dart';
import '../../../presentation/blocs/liked_cats/liked_cats_cubit.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Repositories
  locator.registerSingleton<LikedCatsRepository>(LikedCatsRepositoryImpl());

  // Cubits
  locator.registerFactory(() => LikedCatsCubit(locator<LikedCatsRepository>()));
}