import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'domain/di/di.dart' as di;
import 'presentation/screens/home_screen.dart';
import 'presentation/blocs/liked_cats_cubit.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await di.init();
  // // TODO УДАЛИТЬ ЭТО ПОТОМ
  // WidgetsFlutterBinding.ensureInitialized();
  // final dir = await getApplicationDocumentsDirectory();
  // final file = File('${dir.path}/cat_tinder.sqlite');
  // if (await file.exists()) {
  //   await file.delete();
  //   print('🗑 БД удалена');
  // }
  // // TODO УДАЛИТЬ ЭТО ПОТОМ
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.locator<LikedCatsCubit>())],
      child: MaterialApp(
        title: 'Cat Tinder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
