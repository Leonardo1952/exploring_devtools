import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Level1Page extends StatelessWidget {
  const Level1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Level 1 - Baseline')),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (context, index) {
          return _listTile(index);
        },
      ),
    );
  }

  ListTile _listTile(int index) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: 'https://picsum.photos/50?random=$index',
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        width: 50,
        height: 50,
      ),
      title: Text('Item $index'),
      subtitle: Text('Detailed description for item $index'),
    );
  }
}
