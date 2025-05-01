import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_tinder/data/models/cat.dart';
import 'package:flutter/material.dart';
import 'package:cat_tinder/data/cache_manager/cache_manager.dart';

class CatCard extends StatelessWidget {
  final Cat candidate;

  const CatCard(this.candidate, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: CachedNetworkImage(
              imageUrl: candidate.url,
              cacheManager: CustomCacheManager.instance,
              placeholder:
                  (context, url) => Center(
                    child: Container(
                      padding: const EdgeInsets.all(160),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => const Center(
                    child: SizedBox(
                      height: 350,
                      child: Icon(Icons.error, size: 50, color: Colors.grey),
                    ),
                  ),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.breedName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  candidate.temperament,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  candidate.origin,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
