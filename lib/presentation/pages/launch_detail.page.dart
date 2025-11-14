import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spacex_app/core/utils/image_proxy_helper.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.cubit.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.state.dart';

class LaunchDetailPage extends StatelessWidget {
  final LaunchModel launch;

  const LaunchDetailPage({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    String? largeImageUrl = launch.links.patch.large;
    if (kIsWeb && largeImageUrl != null) {
      largeImageUrl = getProxiedImageUrl(largeImageUrl);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(launch.name),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              bool isFavorite = false;
              if (state is FavoritesLoaded) {
                isFavorite = state.favoriteIds.contains(launch.id);
              }
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () =>
                    context.read<FavoritesCubit>().toggleFavorite(launch.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (largeImageUrl != null)
              Center(
                child: Hero(
                  tag: 'patch_${launch.id}',
                  child: CachedNetworkImage(
                    imageUrl: largeImageUrl,
                    height: 200,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _buildInfoRow(
              'Launch Date:',
              DateFormat.yMMMd().add_jm().format(launch.dateUtc.toLocal()),
            ),
            const SizedBox(height: 12),
            _buildResultSection(),
            const SizedBox(height: 12),
            if (launch.details != null) ...[
              const Divider(height: 32),
              Text('Details', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                launch.details!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 24),
            if (launch.failures.isNotEmpty) ...[
              Text('Failures', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...launch.failures.map(
                (f) => Text(
                  '- ${f.reason}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Rocket ID: ${launch.rocketId}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Widget _buildResultSection() {
    final bool success = launch.success ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.cancel,
              color: success ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              success ? 'Success' : 'Failure',
              style: TextStyle(color: success ? Colors.green : Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
