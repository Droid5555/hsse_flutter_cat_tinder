import 'dart:ui';
import 'package:cat_tinder/data/cache_manager/cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cat_tinder/presentation/blocs/liked_cats_cubit.dart';
import 'package:cat_tinder/presentation/blocs/liked_cats_state.dart';
import 'detail_screen.dart';

class LikedCatsScreen extends StatefulWidget {
  const LikedCatsScreen({super.key});

  @override
  State<LikedCatsScreen> createState() => _LikedCatsScreenState();
}

class _LikedCatsScreenState extends State<LikedCatsScreen> {
  bool _showFilter = false;

  @override
  void initState() {
    super.initState();
    context.read<LikedCatsCubit>().loadLikedCats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Кладезь котиков',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              setState(() => _showFilter = !_showFilter);
            },
          ),
        ],
      ),
      body: BlocBuilder<LikedCatsCubit, LikedCatsState>(
        builder: (context, state) {
          return Column(
            children: [
              if (_showFilter && state.breeds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                  child: DropdownButton<String>(
                    hint: const Text('Фильтр по породе'),
                    value: state.selectedBreed,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Row(
                          children: [
                            Icon(Icons.pets, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Все породы', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                      ...state.breeds.map(
                        (breed) => DropdownMenuItem<String>(
                          value: breed,
                          child: Row(
                            children: [
                              const Icon(Icons.pets, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(breed, style: const TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      context.read<LikedCatsCubit>().filterByBreed(value);
                    },
                  ),
                ),
              Expanded(
                child:
                    state.cats.isEmpty
                        ? const Center(
                          child: Text(
                            'Пока никакой котик тебе не понравился :(',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          itemCount: state.cats.length,
                          itemBuilder: (context, index) {
                            final cat = state.cats[index];
                            return Dismissible(
                              key: ValueKey('${cat.id}_$index'),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                context.read<LikedCatsCubit>().removeLikedCat(
                                  cat.id,
                                  selectedBreed: state.selectedBreed,
                                );
                              },
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: .2),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder:
                                        (context) => Stack(
                                          children: [
                                            GestureDetector(
                                              onTap:
                                                  () =>
                                                      Navigator.of(
                                                        context,
                                                      ).pop(),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 10,
                                                  sigmaY: 10,
                                                ),
                                                child: Container(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.5),
                                                ),
                                              ),
                                            ),
                                            CatDetailScreen(cat: cat),
                                          ],
                                        ),
                                  );
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(50),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: cat.url,
                                        cacheManager:
                                            CustomCacheManager.instance,
                                        width: 130,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                              child: CircularProgressIndicator(
                                                strokeAlign: 1,
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                                const Icon(Icons.error),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cat.breedName,
                                              style: const TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              DateFormat(
                                                'dd/MM/yyyy HH:mm',
                                              ).format(cat.likedAt!),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
