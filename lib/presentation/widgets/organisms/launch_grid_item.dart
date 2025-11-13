import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/presentation/pages/launch_detail.page.dart';

class LaunchGridItem extends StatelessWidget {
  final LaunchModel launch;

  const LaunchGridItem({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    String? imageUrl = launch.links.patch.small;
    if (kIsWeb && imageUrl != null) {
      imageUrl = 'https://cors-anywhere.herokuapp.com/$imageUrl';
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LaunchDetailScreen(launch: launch)),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(launch.name, overflow: TextOverflow.ellipsis),
          ),
          child: Hero(
            tag: 'patch_${launch.id}',
            child: Container(
              color: Colors.grey.shade800,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.rocket_launch,
                        size: 50,
                        color: Colors.white70,
                      ),
                    )
                  : const Icon(
                      Icons.rocket_launch,
                      size: 50,
                      color: Colors.white70,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
