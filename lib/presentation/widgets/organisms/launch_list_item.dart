import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/presentation/pages/launch_detail.page.dart';

class LaunchListItem extends StatelessWidget {
  final LaunchModel launch;

  const LaunchListItem({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    // Handle potential null URL and apply proxy for web.
    String? imageUrl = launch.links.patch.small;
    if (kIsWeb && imageUrl != null) {
      imageUrl = 'https://cors-anywhere.herokuapp.com/$imageUrl';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LaunchDetailScreen(launch: launch),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (imageUrl != null)
                Hero(
                  tag: 'patch_${launch.id}',
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 60,
                    height: 60,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.rocket_launch, size: 40),
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      launch.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(DateFormat.yMMMd().format(launch.dateUtc.toLocal())),
                  ],
                ),
              ),
              Icon(
                launch.success ?? false
                    ? Icons.check_circle_outline
                    : Icons.highlight_off,
                color: launch.success ?? false ? Colors.green : Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
