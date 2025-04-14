import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'dart:ui';
import '../../data/models/cat.dart';
import '../../domain/services/cat_service.dart';
import '../widgets/cat_card.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'detail_screen.dart';
import 'liked_cats_screen.dart';
import '../blocs/liked_cats/liked_cats_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Cat> _catBuffer = [];
  final List<Cat> _swipedCat = [];
  final int _bufferSize = 10;
  bool isLastLike = false;
  int _index = 0;
  int likeCount = 0;
  int dislikeCount = 0;
  final CardSwiperController controller = CardSwiperController();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitialCats();
  }

  void _loadInitialCats() async {
    setState(() => _isLoading = true);
    try {
      final cats = await CatService().fetchRandomCats(_bufferSize);
      setState(() {
        _catBuffer.addAll(cats);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Network error: Failed to load cats';
      });
    }
  }

  void _loadCat(int index) async {
    setState(() => _isLoading = true);
    try {
      final cats = await CatService().fetchRandomCats(1);
      setState(() {
        _catBuffer[index] = cats[0];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Network error: Failed to load cat';
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
      likeCount++;
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
      likeCount--;
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
      builder: (context) => Stack(
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

  void _onInfoTap() {
    _onCardTap(_catBuffer[_index]);
  }

  void _showErrorDialog() {
    if (_error != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
            Image.asset('assets/icon/icon.png', height: 60),
            const SizedBox(width: 10),
            const Text(
              'Ca',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 25,
              ),
            ),
            const Text(
              'Tinder',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.thumb_up, color: Colors.green),
                const SizedBox(width: 5),
                Text('$likeCount'),
                const SizedBox(width: 20),
                const Icon(Icons.thumb_down, color: Colors.red),
                const SizedBox(width: 5),
                Text('$dislikeCount'),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.pink),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LikedCatsScreen()),
                    );
                  },
                ),
              ],
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
                  child: _catBuffer.isEmpty && !_isLoading
                      ? const Center(child: Text('No cats available'))
                      : CardSwiper(
                          controller: controller,
                          cardsCount: _bufferSize,
                          onSwipe: _onSwipe,
                          numberOfCardsDisplayed: 3,
                          backCardOffset: const Offset(40, 40),
                          padding: const EdgeInsets.all(24.0),
                          allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
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
                        onPressed: () => controller.swipe(CardSwiperDirection.left),
                      ),
                      LikeButton(
                        onPressed: () => controller.swipe(CardSwiperDirection.right),
                      ),
                      FloatingActionButton(
                        onPressed: _onInfoTap,
                        backgroundColor: Colors.transparent,
                        shape: const CircleBorder(),
                        child: Image.asset('assets/buttons/info.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}