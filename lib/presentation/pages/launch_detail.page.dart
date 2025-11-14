import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:spacex_app/core/utils/image_proxy_helper.dart';
import 'package:spacex_app/data/api/spacex.service.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/data/models/launchpad.model.dart';
import 'package:spacex_app/data/models/payload.model.dart';
import 'package:spacex_app/data/models/rocket.model.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.cubit.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.state.dart';
import 'package:spacex_app/presentation/bloc/launch_detail/launch_detail_cubit.dart';
import 'package:spacex_app/presentation/bloc/launch_detail/launch_detail_state.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchDetailPage extends StatelessWidget {
  final LaunchModel launch;

  const LaunchDetailPage({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LaunchDetailCubit(
        apiService: SpaceXApiServiceImpl(client: http.Client()),
      )..fetchLaunchDetails(launch),
      child: _LaunchDetailView(initialLaunch: launch),
    );
  }
}

class _LaunchDetailView extends StatelessWidget {
  final LaunchModel initialLaunch;

  const _LaunchDetailView({required this.initialLaunch});

  // Helper function to launch URLs safely
  Future<void> _launchUrl(String? urlString) async {
    if (urlString != null && await canLaunchUrl(Uri.parse(urlString))) {
      await launchUrl(Uri.parse(urlString));
    }
  }

  @override
  Widget build(BuildContext context) {
    String? largeImageUrl = initialLaunch.links.patch.large;
    String? smallImageUrl = initialLaunch.links.patch.small;
    if (kIsWeb) {
      if (largeImageUrl != null) {
        largeImageUrl = getProxiedImageUrl(largeImageUrl);
      }
      if (smallImageUrl != null) {
        smallImageUrl = getProxiedImageUrl(smallImageUrl);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(initialLaunch.name),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              bool isFavorite = false;
              if (state is FavoritesLoaded) {
                isFavorite = state.favoriteIds.contains(initialLaunch.id);
              }
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.pink.shade300 : null,
                ),
                onPressed: () => context.read<FavoritesCubit>().toggleFavorite(
                  initialLaunch.id,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<LaunchDetailCubit, LaunchDetailState>(
        builder: (context, state) {
          if (state is LaunchDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is LaunchDetailLoading || state is LaunchDetailInitial) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildHeader(
                      context,
                      initialLaunch,
                      largeImageUrl,
                      smallImageUrl,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is LaunchDetailLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(
                      context,
                      state.launch,
                      largeImageUrl,
                      smallImageUrl,
                    ),
                    const SizedBox(height: 24),

                    _buildDetailsCard(context, state.launch),

                    _buildRocketGeneralInfoCard(context, state.rocket),
                    _buildRocketImageGallery(
                      context,
                      state.rocket.flickrImages,
                    ),
                    _buildRocketSpecsCard(context, state.rocket),
                    _buildRocketStagesCard(context, state.rocket),

                    _buildPayloadCapacityCard(
                      context,
                      state.rocket.payloadWeights,
                    ),

                    _buildLaunchpadInfoCard(context, state.launchpad),

                    if (state.payloads.isNotEmpty)
                      _buildPayloadsInfoCard(context, state.payloads),

                    if (state.launch.cores.isNotEmpty)
                      _buildCoreInfoCard(context, state.launch.cores),

                    _buildLinksCard(context, state.launch),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    LaunchModel launch,
    String? largeImageUrl,
    String? smallImageUrl,
  ) {
    final displayUrl = largeImageUrl ?? smallImageUrl;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (displayUrl != null)
            Hero(
              tag: 'patch_${launch.id}',
              child: CachedNetworkImage(
                imageUrl: displayUrl,
                height: 150,
                fit: BoxFit.contain,
                placeholder: (context, url) {
                  if (smallImageUrl != null && largeImageUrl != null) {
                    return CachedNetworkImage(
                      imageUrl: smallImageUrl,
                      fit: BoxFit.contain,
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
                errorWidget: (context, url, error) {
                  if (smallImageUrl != null) {
                    return CachedNetworkImage(
                      imageUrl: smallImageUrl,
                      fit: BoxFit.contain,
                    );
                  }
                  return const Icon(Icons.error, size: 50);
                },
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
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, LaunchModel launch) {
    if (launch.details == null && launch.failures.isEmpty) {
      return const SizedBox.shrink();
    }
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
            if (launch.details != null) const SizedBox(height: 16),
            Text(
              'Failures:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
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

  Widget _buildRocketGeneralInfoCard(BuildContext context, RocketModel rocket) {
    final costFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
    );
    return _InfoCard(
      title: 'Rocket: ${rocket.name}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rocket.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Company', value: rocket.company),
          _InfoRow(
            label: 'First Flight',
            value: DateFormat.yMMMMd().format(rocket.firstFlight),
          ),
          _InfoRow(label: 'Success Rate', value: '${rocket.successRatePct}%'),
          _InfoRow(
            label: 'Cost Per Launch',
            value: costFormat.format(rocket.costPerLaunch),
          ),
          _InfoRow(
            label: 'Status',
            value: rocket.active ? 'Active' : 'Inactive',
          ),
          _LinkButton(
            text: 'View on Wikipedia',
            icon: Icons.public,
            onPressed: () => _launchUrl(rocket.wikipedia),
          ),
        ],
      ),
    );
  }

  Widget _buildRocketImageGallery(BuildContext context, List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text("Gallery", style: Theme.of(context).textTheme.titleLarge),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              final imageUrl = kIsWeb
                  ? getProxiedImageUrl(images[index])
                  : images[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 250,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRocketSpecsCard(BuildContext context, RocketModel rocket) {
    final massFormat = NumberFormat.decimalPattern('en_US');
    return _InfoCard(
      title: 'Specifications',
      child: Column(
        children: [
          _InfoRow(
            label: 'Height',
            value: '${rocket.height.meters} m / ${rocket.height.feet} ft',
          ),
          _InfoRow(
            label: 'Diameter',
            value: '${rocket.diameter.meters} m / ${rocket.diameter.feet} ft',
          ),
          _InfoRow(
            label: 'Mass',
            value:
                '${massFormat.format(rocket.mass.kg)} kg / ${massFormat.format(rocket.mass.lb)} lb',
          ),
          _InfoRow(label: 'Stages', value: rocket.stages.toString()),
          _InfoRow(label: 'Boosters', value: rocket.boosters.toString()),
        ],
      ),
    );
  }

  Widget _buildRocketStagesCard(BuildContext context, RocketModel rocket) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return _InfoCard(
      title: 'Stages & Engines',
      child: Theme(
        data: theme,
        child: Column(
          children: [
            ExpansionTile(
              title: const Text('First Stage'),
              tilePadding: EdgeInsets.zero,
              children: [
                _InfoRow(
                  label: 'Engines',
                  value: rocket.firstStage.engines.toString(),
                ),
                _InfoRow(
                  label: 'Fuel Amount',
                  value: '${rocket.firstStage.fuelAmountTons} tons',
                ),
                _InfoRow(
                  label: 'Burn Time',
                  value: '${rocket.firstStage.burnTimeSec ?? 'N/A'} sec',
                ),
                _InfoRow(
                  label: 'Thrust (Sea Level)',
                  value: '${rocket.firstStage.thrustSeaLevel?.kN ?? 'N/A'} kN',
                ),
                _InfoRow(
                  label: 'Thrust (Vacuum)',
                  value: '${rocket.firstStage.thrustVacuum?.kN ?? 'N/A'} kN',
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Second Stage'),
              tilePadding: EdgeInsets.zero,
              children: [
                _InfoRow(
                  label: 'Engines',
                  value: rocket.secondStage.engines.toString(),
                ),
                _InfoRow(
                  label: 'Fuel Amount',
                  value: '${rocket.secondStage.fuelAmountTons} tons',
                ),
                _InfoRow(
                  label: 'Burn Time',
                  value: '${rocket.secondStage.burnTimeSec ?? 'N/A'} sec',
                ),
                _InfoRow(
                  label: 'Thrust',
                  value: '${rocket.secondStage.thrust?.kN ?? 'N/A'} kN',
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Engines (${rocket.engines.type})'),
              tilePadding: EdgeInsets.zero,
              children: [
                _InfoRow(
                  label: 'Type',
                  value: '${rocket.engines.type} ${rocket.engines.version}',
                ),
                _InfoRow(
                  label: 'Number',
                  value: rocket.engines.number.toString(),
                ),
                _InfoRow(
                  label: 'Layout',
                  value: rocket.engines.layout ?? 'N/A',
                ),
                _InfoRow(
                  label: 'Propellant 1',
                  value: rocket.engines.propellant1,
                ),
                _InfoRow(
                  label: 'Propellant 2',
                  value: rocket.engines.propellant2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayloadCapacityCard(
    BuildContext context,
    List<PayloadWeightModel> payloads,
  ) {
    final massFormat = NumberFormat.decimalPattern('en_US');
    return _InfoCard(
      title: 'Payload Capacity',
      child: Column(
        children: payloads
            .map(
              (p) => _InfoRow(
                label: p.name,
                value: '${massFormat.format(p.kg)} kg',
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLaunchpadInfoCard(
    BuildContext context,
    LaunchpadModel launchpad,
  ) {
    return _InfoCard(
      title: 'Launchpad',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (launchpad.images.large.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: launchpad.images.large.length,
                  itemBuilder: (context, index) {
                    final imageUrl = kIsWeb
                        ? getProxiedImageUrl(launchpad.images.large[index])
                        : launchpad.images.large[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.only(right: 12.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 250,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  },
                ),
              ),
            ),
          Text(
            launchpad.fullName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(launchpad.details, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          _InfoRow(
            label: 'Location',
            value: '${launchpad.locality}, ${launchpad.region}',
          ),
          _InfoRow(
            label: 'Timezone',
            value: launchpad.timezone.replaceAll('/', ', ').replaceAll('_', ' '),
          ),
          _InfoRow(
            label: 'Status',
            value: launchpad.status == 'active' ? 'Active' : 'Inactive',
          ),
          _InfoRow(
            label: 'Successful Launches',
            value: '${launchpad.launchSuccesses} / ${launchpad.launchAttempts}',
          ),
        ],
      ),
    );
  }

  Widget _buildPayloadsInfoCard(
    BuildContext context,
    List<PayloadModel> payloads,
  ) {
    return _InfoCard(
      title: 'Payloads (${payloads.length})',
      child: Column(
        children: payloads.asMap().entries.map((entry) {
          int idx = entry.key;
          PayloadModel payload = entry.value;
          return Padding(
            padding: EdgeInsets.only(top: idx > 0 ? 16.0 : 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payload.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                _InfoRow(label: 'Type', value: payload.type ?? 'N/A'),
                _InfoRow(
                  label: 'Nationality',
                  value: payload.nationality ?? 'N/A',
                ),
                _InfoRow(
                  label: 'Mass',
                  value: payload.massKg != null
                      ? '${payload.massKg} kg'
                      : 'N/A',
                ),
                _InfoRow(label: 'Orbit', value: payload.orbit ?? 'N/A'),
                _InfoRow(
                  label: 'Customers',
                  value: payload.customers.join(', '),
                ),
                if (idx < payloads.length - 1) const Divider(height: 24),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoreInfoCard(BuildContext context, List<CoreModel> cores) {
    return _InfoCard(
      title: 'Rocket Core Details',
      child: Column(
        children: cores.asMap().entries.map((entry) {
          int idx = entry.key;
          CoreModel core = entry.value;
          return Padding(
            padding: EdgeInsets.only(top: idx > 0 ? 16.0 : 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cores.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Core #${idx + 1}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
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

  Widget _buildLinksCard(BuildContext context, LaunchModel launch) {
    if (launch.links.webcast == null &&
        launch.links.article == null &&
        launch.links.wikipedia == null) {
      return const SizedBox.shrink();
    }
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
      clipBehavior: Clip.antiAlias,
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
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
            ),
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
