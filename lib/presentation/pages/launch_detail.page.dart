import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spacex_app/core/utils/image_proxy_helper.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.cubit.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.state.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchDetailPage extends StatelessWidget {
  final LaunchModel launch;

  const LaunchDetailPage({super.key, required this.launch});

  // Helper function to launch URLs safely
  Future<void> _launchUrl(String? urlString) async {
    if (urlString != null && await canLaunchUrl(Uri.parse(urlString))) {
      await launchUrl(Uri.parse(urlString));
    }
  }

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
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.pink.shade300 : null,
                ),
                onPressed: () =>
                    context.read<FavoritesCubit>().toggleFavorite(launch.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, largeImageUrl),
              const SizedBox(height: 24),

              if (launch.details != null || launch.failures.isNotEmpty)
                _buildDetailsCard(context),

              _buildMissionInfoCard(context),

              if (launch.cores.isNotEmpty) _buildCoreInfoCard(context),

              if (launch.links.webcast != null ||
                  launch.links.article != null ||
                  launch.links.wikipedia != null)
                _buildLinksCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? imageUrl) {
    return Column(
      children: [
        if (imageUrl != null)
          Hero(
            tag: 'patch_${launch.id}',
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 150,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 50),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Flight #${launch.flightNumber}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          launch.name,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _StatusTag(success: launch.success),
        const SizedBox(height: 12),
        Text(
          DateFormat.yMMMMd().add_jm().format(launch.dateUtc.toLocal()),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade400),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return _InfoCard(
      title: 'Launch Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (launch.details != null)
            Text(
              launch.details!,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          if (launch.failures.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Failures:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            ...launch.failures.map(
              (f) => Text(
                '• ${f.reason}',
                style: TextStyle(color: Colors.red.shade300),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMissionInfoCard(BuildContext context) {
    return _InfoCard(
      title: 'Mission Info',
      child: Column(
        children: [
          _InfoRow(label: 'Rocket ID', value: launch.rocketId),
          _InfoRow(label: 'Launchpad ID', value: launch.launchpad),
          if (launch.crew.isNotEmpty)
            _InfoRow(
              label: 'Crew Members',
              value: launch.crew.length.toString(),
            ),
          if (launch.capsules.isNotEmpty)
            _InfoRow(
              label: 'Capsules',
              value: launch.capsules.length.toString(),
            ),
          if (launch.payloads.isNotEmpty)
            _InfoRow(
              label: 'Payloads',
              value: launch.payloads.length.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildCoreInfoCard(BuildContext context) {
    return _InfoCard(
      title: 'Rocket Core Details',
      child: Column(
        children: launch.cores.asMap().entries.map((entry) {
          int idx = entry.key;
          CoreModel core = entry.value;
          return Padding(
            padding: EdgeInsets.only(top: idx > 0 ? 16.0 : 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (launch.cores.length > 1)
                  Text(
                    "Core #${idx + 1}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                _InfoRow(label: 'Core ID', value: core.core ?? 'N/A'),
                _InfoRow(
                  label: 'Flights on this Core',
                  value: core.flight?.toString() ?? 'N/A',
                ),
                _InfoRow(
                  label: 'Reused',
                  value: core.reused ?? false ? 'Yes' : 'No',
                ),
                _InfoRow(
                  label: 'Landing Attempt',
                  value: core.landingAttempt ?? false ? 'Yes' : 'No',
                ),
                _InfoRow(
                  label: 'Landing Success',
                  value: core.landingSuccess ?? false ? 'Yes' : 'No',
                  valueColor: core.landingSuccess == true
                      ? Colors.green.shade300
                      : Colors.red.shade300,
                ),
                _InfoRow(
                  label: 'Landing Type',
                  value: core.landingType ?? 'N/A',
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLinksCard(BuildContext context) {
    return _InfoCard(
      title: 'Find Out More',
      child: Column(
        children: [
          if (launch.links.webcast != null)
            _LinkButton(
              text: 'Watch on YouTube',
              icon: Icons.play_circle_outline,
              onPressed: () => _launchUrl(launch.links.webcast),
            ),
          if (launch.links.article != null)
            _LinkButton(
              text: 'Read Article',
              icon: Icons.article_outlined,
              onPressed: () => _launchUrl(launch.links.article),
            ),
          if (launch.links.wikipedia != null)
            _LinkButton(
              text: 'View on Wikipedia',
              icon: Icons.public,
              onPressed: () => _launchUrl(launch.links.wikipedia),
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24.0),
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 24.0),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final bool? success;

  const _StatusTag({required this.success});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = success ?? false;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isSuccess
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isSuccess ? Colors.green.shade300 : Colors.red.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.cancel,
            color: isSuccess ? Colors.green.shade300 : Colors.red.shade300,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            isSuccess ? 'SUCCESS' : 'FAILURE',
            style: TextStyle(
              color: isSuccess ? Colors.green.shade300 : Colors.red.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const _LinkButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(text),
        style: TextButton.styleFrom(
          foregroundColor: Colors.blueAccent.shade100,
          minimumSize: const Size(double.infinity, 44),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
