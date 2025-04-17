import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'dart:ui';
import 'package:cat_tinder/data/models/cat.dart';
import 'package:cat_tinder/data/services/cat_service.dart';
import 'package:cat_tinder/presentation/blocs/liked_cats_state.dart';
import 'package:cat_tinder/presentation/widgets/cat_card.dart';
import 'package:cat_tinder/presentation/widgets/like_button.dart';
import 'package:cat_tinder/presentation/widgets/dislike_button.dart';
import 'detail_screen.dart';
import 'liked_cats_screen.dart';
import 'package:cat_tinder/presentation/blocs/liked_cats_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Cat> _catBuffer = [];
  final List<Cat> _swipedCat = [];
  final int _bufferSize = 10;
  bool isLastLike = false;
  int _index = 0;
  int dislikeCount = 0;
  final CardSwiperController controller = CardSwiperController();
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialCats();
  }

  void _loadInitialCats() async {
    try {
      final cats = await CatService().fetchRandomCats(_bufferSize);
      setState(() {
        _catBuffer.addAll(cats);
      });
    } catch (e) {
      setState(() {
        _error = 'Котики не найдены. Проверьте подключение к интернету.';
      });
    }
  }

  void _loadCat(int index) async {
    try {
      final cats = await CatService().fetchRandomCats(1);
      setState(() {
        _catBuffer[index] = cats[0];
      });
    } catch (e) {
      setState(() {
        _error = 'Котики не найдены. Проверьте подключение к интернету.';
      });
    }
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction == CardSwiperDirection.right) {
      _onLike();
    } else {
      _onDislike();
    }
    _index = currentIndex!;
    if (_swipedCat.isEmpty) {
      _swipedCat.add(_catBuffer[previousIndex]);
    } else {
      _swipedCat[0] = _catBuffer[previousIndex];
    }
    _loadCat(previousIndex);
    return true;
  }

  void _onLike() {
    setState(() {
      isLastLike = true;
    });
    context.read<LikedCatsCubit>().addLikedCat(_catBuffer[_index]);
  }

  void _onDislike() {
    setState(() {
      dislikeCount++;
      isLastLike = false;
    });
  }

  void _onUndo() {
    if (isLastLike) {
      context.read<LikedCatsCubit>().removeLikedCat(_swipedCat.last.id);
    } else {
      dislikeCount--;
    }
    setState(() {
      _catBuffer[(_index + 1) % _bufferSize] = _catBuffer[_index];
      _catBuffer[_index] = _swipedCat.removeLast();
    });
  }

  void _onCardTap(Cat cat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withValues(alpha: 0.5)),
                ),
              ),
              CatDetailScreen(cat: cat),
            ],
          ),
    );
  }

  void _onMenuTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LikedCatsScreen()),
    );
  }

  void _showErrorDialog() {
    if (_error != null) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(_error!),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() => _error = null);
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showErrorDialog());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icon/icon.png', height: 55),
            const SizedBox(width: 10),
            const Text(
              'Кот',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 30,
              ),
            ),
            const Text(
              'олог',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 28,
              ),
            ),
            const Spacer(),
            BlocBuilder<LikedCatsCubit, LikedCatsState>(
              builder: (context, state) {
                return Row(
                  children: [
                    const Icon(Icons.thumb_up, color: Colors.green),
                    const SizedBox(width: 5),
                    Text('${state.cats.length}'),
                    const SizedBox(width: 20),
                    const Icon(Icons.thumb_down, color: Colors.red),
                    const SizedBox(width: 5),
                    Text('$dislikeCount'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child:
                      _catBuffer.isEmpty
                          ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Загружаем котиков...',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 5),
                                SizedBox(
                                  width: 200,
                                  child: LinearProgressIndicator(
                                    minHeight: 3,
                                    backgroundColor: Colors.black12,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : CardSwiper(
                            controller: controller,
                            cardsCount: _bufferSize,
                            onSwipe: _onSwipe,
                            numberOfCardsDisplayed: 3,
                            backCardOffset: const Offset(40, 40),
                            padding: const EdgeInsets.all(24.0),
                            allowedSwipeDirection:
                                const AllowedSwipeDirection.symmetric(
                                  horizontal: true,
                                ),
                            cardBuilder: (
                              context,
                              index,
                              horizontalThresholdPercentage,
                              verticalThresholdPercentage,
                            ) {
                              final cat = _catBuffer[index];
                              return GestureDetector(
                                onTap: () => _onCardTap(cat),
                                child: CatCard(cat),
                              );
                            },
                          ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Opacity(
                        opacity: _swipedCat.isNotEmpty ? 1.0 : 0.5,
                        child: FloatingActionButton(
                          onPressed: _swipedCat.isNotEmpty ? _onUndo : null,
                          backgroundColor: Colors.transparent,
                          shape: const CircleBorder(),
                          child: Image.asset('assets/buttons/arrow.png'),
                        ),
                      ),
                      DislikeButton(
                        onPressed:
                            () => controller.swipe(CardSwiperDirection.left),
                      ),
                      LikeButton(
                        onPressed:
                            () => controller.swipe(CardSwiperDirection.right),
                      ),
                      FloatingActionButton(
                        onPressed: _onMenuTap,
                        backgroundColor: Colors.transparent,
                        shape: const CircleBorder(),
                        child: Image.asset('assets/buttons/menu.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
