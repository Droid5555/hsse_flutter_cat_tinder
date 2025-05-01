import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cat_tinder/data/models/cat.dart';
import 'package:cat_tinder/data/cache_manager/cache_manager.dart';

class CatDetailScreen extends StatelessWidget {
  final Cat cat;

  const CatDetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
        top: 100.0,
        left: 16.0,
        right: 16.0,
        bottom: 120.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,

          children: [
            CachedNetworkImage(
              imageUrl: cat.url,
              cacheManager: CustomCacheManager.instance,
              placeholder:
                  (context, url) =>
                      const Center(child: CircularProgressIndicator()),
              errorWidget:
                  (context, url, error) =>
                      const Center(child: const Icon(Icons.error, size: 350, color: Colors.grey,)),
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 7.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                cat.breedName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 3.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                cat.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Wrap(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 3),
                  Text(
                    'Origin: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                cat.origin,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            const SizedBox(height: 11.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Wrap(
                children: [
                  Icon(Icons.pets, color: Colors.blue),
                  SizedBox(width: 3),
                  Text(
                    'Temperament: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                cat.temperament,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
