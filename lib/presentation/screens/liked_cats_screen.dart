import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/liked_cats/liked_cats_cubit.dart';
import '../blocs/liked_cats/liked_cats_state.dart';
import '../widgets/cat_card.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LikedCatsCubit>().loadLikedCats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
      ),
      body: BlocBuilder<LikedCatsCubit, LikedCatsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  hint: const Text('Filter by breed'),
                  value: state.selectedBreed,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Breeds'),
                    ),
                    ...state.breeds.map((breed) => DropdownMenuItem<String>(
                          value: breed,
                          child: Text(breed),
                        )),
                  ],
                  onChanged: (value) {
                    context.read<LikedCatsCubit>().filterByBreed(value);
                  },
                ),
              ),
              Expanded(
                child: state.cats.isEmpty
                    ? const Center(child: Text('No liked cats yet'))
                    : ListView.builder(
                        itemCount: state.cats.length,
                        itemBuilder: (context, index) {
                          final cat = state.cats[index];
                          return Dismissible(
                            key: Key(cat.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              context.read<LikedCatsCubit>().removeLikedCat(cat.id);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: CatCard(cat),
                              ),
                              title: Text(cat.breedName),
                              subtitle: Text(
                                'Liked on: ${DateFormat('dd/MM/yyyy').format(cat.likedAt!)}',
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