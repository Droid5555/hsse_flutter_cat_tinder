import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/liked_cats/liked_cats_cubit.dart';
import '../blocs/liked_cats/liked_cats_state.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LikedCatsCubit>().loadLikedCats();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'История лайков',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<LikedCatsCubit, LikedCatsState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state.breeds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    hint: const Text('Фильтр по породе'),
                    value:
                        state.breeds.contains(state.selectedBreed)
                            ? state.selectedBreed
                            : null,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Row(
                          children: [
                            Icon(Icons.pets, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Все породы'),
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
                              Text(breed),
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
                            'Никакой котик тебе не понравился :(',
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
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CachedNetworkImage(
                                    imageUrl: cat.url,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                            const Icon(Icons.error),
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  cat.breedName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat(
                                    'dd/MM/yyyy hh:mm',
                                  ).format(cat.likedAt!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
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
