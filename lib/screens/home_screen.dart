import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'dart:ui';
import '../models/cat.dart';
import '../models/cat_card.dart';
import '../services/cat_service.dart';
import 'detail_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadInitialCats();
  }

  void _loadInitialCats() async {
    final cats = await CatService().fetchRandomCats(_bufferSize);
    setState(() {
      _catBuffer.addAll(cats);
    });
  }

  void _loadCat(int index) async {
    final cats = await CatService().fetchRandomCats(1);
    setState(() {
      _catBuffer[index] = cats[0];
    });
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
    return true; // Return a boolean value
  }

  void _onLike() {
    setState(() {
      likeCount++;
      isLastLike = true;
    });
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

  void _onInfoTap() {
    _onCardTap(_catBuffer[_index]);
  }

  @override
  Widget build(BuildContext context) {
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
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child:
                  _catBuffer.isEmpty
                      ? const Center(child: CircularProgressIndicator())
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
                  FloatingActionButton.large(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    backgroundColor: Colors.transparent,
                    shape: const CircleBorder(),
                    child: Image.asset('assets/buttons/cross.png'),
                  ),
                  FloatingActionButton.large(
                    onPressed:
                        () => controller.swipe(CardSwiperDirection.right),
                    backgroundColor: Colors.transparent,
                    shape: const CircleBorder(),
                    child: Image.asset('assets/buttons/heart.png'),
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
      ),
    );
  }
}
