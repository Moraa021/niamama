import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../services/location_service.dart';
import '../theme/nurture_bloom_theme.dart';

class CareMapScreen extends StatefulWidget {
  final UserCoordinates userCoords;
  final GpsPermissionStatus gpsStatus;
  final VoidCallback onRequestLocation;
  final VoidCallback onOpenSpeedDial;
  final void Function(String message) onShowToast;

  const CareMapScreen({
    super.key,
    required this.userCoords,
    required this.gpsStatus,
    required this.onRequestLocation,
    required this.onOpenSpeedDial,
    required this.onShowToast,
  });

  @override
  State<CareMapScreen> createState() => _CareMapScreenState();
}

class _CareMapScreenState extends State<CareMapScreen> {
  static const String _mapBgUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCuiwoz8vPyVu2GbZ81RLV1uHJiTymqnNL-VNOS7JyIVAf84X6CyHpMUI56xCjwnri7CdIUlaY-j9k6rG78nlNcrlur5GPLgMpuwB1k6GHB-27xx0fLYjjXTClp6Xj8iGzuys4Jpbse2M8CGMWBteBoCkR4X3pNDii3Hlo5SrJteMrzeQb9_VBYXbivlplc-y-8q7SB082xC7k7dYF7zJA5Phn5UK1i0rNsv5vBM8k';

  String _activeFilter = 'all';
  String _searchQuery = '';
  bool _accordionExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  static const List<Map<String, String>> _filters = [
    {'id': 'all', 'label': 'All Facilities'},
    {'id': 'maternity', 'label': '24/7 Maternity'},
    {'id': 'pediatric', 'label': 'Pediatric Wings'},
    {'id': 'vaccines', 'label': 'Vaccine Clinics'},
    {'id': 'midwife', 'label': 'Midwife Run'},
    {'id': 'pharmacy', 'label': '24h Chemists'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enriched = LocationService.facilities.map((facility) {
      final distKm = LocationService.calculateDistanceKm(
        widget.userCoords.lat,
        widget.userCoords.lng,
        facility.lat,
        facility.lng,
      );
      final mins = LocationService.estimateTravelMinutes(
        distKm,
        facility.isWalkingMode,
      );
      return (facility: facility, distKm: distKm, mins: mins);
    }).toList();

    if (widget.userCoords.isLiveGps) {
      enriched.sort((a, b) => a.mins.compareTo(b.mins));
    }

    final filtered = enriched.where((item) {
      final f = item.facility;
      final matchesFilter = _activeFilter == 'all'
          ? !f.tags.contains('pharmacy')
          : f.tags.contains(_activeFilter);
      final target =
          '${f.name} ${f.badgeText} ${f.statusHeadline} ${f.capabilities.join(" ")}'
              .toLowerCase();
      final matchesSearch = _searchQuery.trim().isEmpty ||
          target.contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        // Top Status Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: widget.onRequestLocation,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.primaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: NurtureBloomColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.gpsStatus == GpsPermissionStatus.requesting
                          ? 'Locating GPS...'
                          : widget.userCoords.isLiveGps
                              ? 'Care Map Active • GPS ±${widget.userCoords.accuracy.round()}m'
                              : 'Care Map Active • Tap for Live GPS',
                      style: NurtureBloomTextStyles.labelSm.copyWith(
                        color: NurtureBloomColors.onPrimaryFixed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: widget.onRequestLocation,
              child: Row(
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    size: 16,
                    color: NurtureBloomColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.userCoords.areaName,
                    style: NurtureBloomTextStyles.labelSm,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Trusted Care Near You',
          style: NurtureBloomTextStyles.headlineLgMobile,
        ),
        const SizedBox(height: 2),
        Text(
          'Verified maternal wings, neonatal care, and gentle walk-in clinics.',
          style: NurtureBloomTextStyles.bodySm,
        ),
        const SizedBox(height: 12),

        // Live GPS Permission Prompt Banner (shown until granted)
        if (widget.gpsStatus != GpsPermissionStatus.granted)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NurtureBloomColors.secondaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: NurtureBloomColors.surfaceContainerLowest,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_searching_rounded,
                    color: NurtureBloomColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.gpsStatus == GpsPermissionStatus.denied
                            ? 'Location Permission Needed'
                            : 'Enable Live GPS Routing',
                        style: NurtureBloomTextStyles.labelMd,
                      ),
                      Text(
                        'Grant location permission to calculate exact distances and emergency routes from your spot.',
                        style: NurtureBloomTextStyles.bodySm,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: widget.onRequestLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NurtureBloomColors.primary,
                    foregroundColor: NurtureBloomColors.onPrimary,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: const Text('Allow GPS'),
                ),
              ],
            ),
          ),

        // Search Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: NurtureBloomColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search facility name, midwife, or care type...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _activeFilter = 'all';
                  });
                },
                icon: const Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: NurtureBloomColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Filter Pills
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final f = _filters[idx];
              final isSelected = _activeFilter == f['id'];
              return InkWell(
                onTap: () => setState(() => _activeFilter = f['id']!),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? NurtureBloomColors.primary
                        : NurtureBloomColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    f['label']!,
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: isSelected
                          ? NurtureBloomColors.onPrimary
                          : NurtureBloomColors.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Map Preview Banner
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 205,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  _mapBgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: NurtureBloomColors.surfaceContainerHigh,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        NurtureBloomColors.inverseSurface.withValues(alpha: 0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: NurtureBloomColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.userCoords.isLiveGps
                              ? 'You (${widget.userCoords.lat.toStringAsFixed(3)}°, ${widget.userCoords.lng.toStringAsFixed(3)}°)'
                              : 'You are here',
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            color: NurtureBloomColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 48,
                  right: 24,
                  child: _buildMapPin(
                    icon: Icons.local_hospital_rounded,
                    iconColor: NurtureBloomColors.primary,
                    label:
                        '${enriched[0].distKm} km • ${enriched[0].mins}m',
                  ),
                ),
                Positioned(
                  bottom: 48,
                  left: 36,
                  child: _buildMapPin(
                    icon: Icons.emergency_rounded,
                    iconColor: NurtureBloomColors.tertiary,
                    label:
                        '${enriched[1].distKm} km • ${enriched[1].mins}m',
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: _buildMapPin(
                    icon: Icons.child_care_rounded,
                    iconColor: NurtureBloomColors.primary,
                    label:
                        '${enriched[2].distKm} km • ${enriched[2].mins}m walk',
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.traffic_rounded,
                          size: 15,
                          color: NurtureBloomColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Calm traffic along Ring Road',
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            color: NurtureBloomColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Nearest Facilities Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.near_me_rounded,
                  size: 20,
                  color: NurtureBloomColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Nearest Facilities',
                  style: NurtureBloomTextStyles.headlineSm,
                ),
              ],
            ),
            Text(
              widget.userCoords.isLiveGps
                  ? 'Sorted by live GPS distance'
                  : 'Sorted by travel time',
              style: NurtureBloomTextStyles.labelSm,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Facilities Cards
        ...filtered.map((item) {
          final f = item.facility;
          final isPrimary = f.id == 'sub-county-referral';
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              boxShadow: NurtureBloomColors.ambientWarmShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: f.isPrimaryVariant
                                      ? NurtureBloomColors.primaryFixed
                                      : NurtureBloomColors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  f.badgeText,
                                  style:
                                      NurtureBloomTextStyles.labelSm.copyWith(
                                    color: f.isPrimaryVariant
                                        ? NurtureBloomColors.onPrimaryFixed
                                        : NurtureBloomColors
                                            .onSecondaryContainer,
                                  ),
                                ),
                              ),
                              if (f.secondaryBadge != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        NurtureBloomColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    f.secondaryBadge!,
                                    style: NurtureBloomTextStyles.labelSm,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            f.name,
                            style: NurtureBloomTextStyles.headlineSm,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                f.isWalkingMode
                                    ? Icons.directions_walk_rounded
                                    : Icons.navigation_rounded,
                                size: 15,
                                color: NurtureBloomColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${item.distKm} km away • Approx. ${item.mins} mins ${f.isWalkingMode ? "walk" : "drive"}${isPrimary ? " • Open 24/7" : ""}',
                                  style: NurtureBloomTextStyles.bodySm,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: f.isPrimaryVariant
                            ? NurtureBloomColors.primaryFixed
                            : NurtureBloomColors.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        f.icon,
                        size: 22,
                        color: f.isPrimaryVariant
                            ? NurtureBloomColors.onPrimaryFixed
                            : NurtureBloomColors.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Wait Status Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: NurtureBloomColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: NurtureBloomColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            f.statusHeadline,
                            style: NurtureBloomTextStyles.labelSm.copyWith(
                              color: NurtureBloomColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        f.statusSubtext,
                        style: NurtureBloomTextStyles.labelSm,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Capabilities
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: f.capabilities.map((cap) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: NurtureBloomColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        cap,
                        style: NurtureBloomTextStyles.labelSm,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Actions
                if (isPrimary) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        LocationService.dialNumber(f.phone);
                        widget.onShowToast('Calling ${f.name} Triage Hotline...');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NurtureBloomColors.primary,
                        foregroundColor: NurtureBloomColors.onPrimary,
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.phone_in_talk_rounded, size: 20),
                      label: Text(
                        f.primaryCtaLabel,
                        style: NurtureBloomTextStyles.labelLg.copyWith(
                          color: NurtureBloomColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton.icon(
                      onPressed: () {
                        LocationService.openDirections(
                          userCoords: widget.userCoords,
                          destLat: f.lat,
                          destLng: f.lng,
                          isWalking: f.isWalkingMode,
                        );
                        widget.onShowToast(
                          'Opening directions to ${f.name} (${item.distKm} km)',
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: NurtureBloomColors.secondaryFixed,
                        foregroundColor: NurtureBloomColors.onSecondaryFixed,
                        shape: const StadiumBorder(),
                      ),
                      icon: const Icon(Icons.directions_rounded, size: 18),
                      label: Text(f.secondaryCtaLabel),
                    ),
                  ),
                ] else
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextButton.icon(
                            onPressed: () {
                              LocationService.dialNumber(f.phone);
                              widget.onShowToast('Calling ${f.name}...');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  NurtureBloomColors.surfaceContainer,
                              foregroundColor: NurtureBloomColors.onSurface,
                              shape: const StadiumBorder(),
                            ),
                            icon: const Icon(Icons.call_rounded, size: 18),
                            label: Text(f.primaryCtaLabel),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextButton.icon(
                            onPressed: () {
                              LocationService.openDirections(
                                userCoords: widget.userCoords,
                                destLat: f.lat,
                                destLng: f.lng,
                                isWalking: f.isWalkingMode,
                              );
                              widget.onShowToast(
                                'Opening route to ${f.name} (${item.distKm} km)',
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: NurtureBloomColors.primaryFixed,
                              foregroundColor:
                                  NurtureBloomColors.onPrimaryFixed,
                              shape: const StadiumBorder(),
                            ),
                            icon: Icon(
                              f.isWalkingMode
                                  ? Icons.directions_walk_rounded
                                  : Icons.directions_rounded,
                              size: 18,
                            ),
                            label: Text(f.secondaryCtaLabel),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),

        // Emergency & Triage Guidance Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NurtureBloomColors.secondaryFixed.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: NurtureBloomColors.tertiaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: NurtureBloomColors.onTertiaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency & Triage Guidance',
                          style: NurtureBloomTextStyles.headlineSm,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'You know your baby best. If you ever feel uneasy, trust your maternal instinct—care teams are here without judgment.',
                          style: NurtureBloomTextStyles.bodySm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Collapsible Accordion
              Container(
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => setState(
                        () => _accordionExpanded = !_accordionExpanded,
                      ),
                      leading: const Icon(
                        Icons.info_outline_rounded,
                        color: NurtureBloomColors.tertiary,
                      ),
                      title: Text(
                        'When to seek immediate emergency care',
                        style: NurtureBloomTextStyles.labelLg,
                      ),
                      trailing: Icon(
                        _accordionExpanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                      ),
                    ),
                    if (_accordionExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Column(
                          children: const [
                            _EmergencyGuidanceRow(
                              icon: Icons.air_rounded,
                              title: 'Breathing difficulties:',
                              description:
                                  'Grunting noises, flaring nostrils, or chest pulling in deeply under the ribs.',
                            ),
                            SizedBox(height: 8),
                            _EmergencyGuidanceRow(
                              icon: Icons.device_thermostat_rounded,
                              title: 'High fever (>38°C / 100.4°F):',
                              description:
                                  'Any fever in an infant under 3 months needs urgent professional assessment.',
                            ),
                            SizedBox(height: 8),
                            _EmergencyGuidanceRow(
                              icon: Icons.bedtime_rounded,
                              title: 'Severe lethargy or floppiness:',
                              description:
                                  'Unusually difficult to wake up, not responding to maternal voice, or refusing 2 consecutive feeds.',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    LocationService.dialNumber('1190');
                    widget.onShowToast(
                      'Calling 24/7 National Maternal Helpline (1190)...',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NurtureBloomColors.tertiary,
                    foregroundColor: NurtureBloomColors.onTertiary,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 22),
                  label: Text(
                    'Call 24/7 National Maternal Helpline (Free)',
                    style: NurtureBloomTextStyles.labelLg.copyWith(
                      color: NurtureBloomColors.onTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton.icon(
                  onPressed: widget.onOpenSpeedDial,
                  style: TextButton.styleFrom(
                    backgroundColor: NurtureBloomColors.surfaceContainerLowest,
                    foregroundColor: NurtureBloomColors.tertiary,
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.emergency_share_rounded, size: 18),
                  label: const Text('Open Emergency Speed-Dial & GPS SOS'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Late-Night Pharmacies Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: NurtureBloomColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_pharmacy_rounded,
                  color: NurtureBloomColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Looking for late-night pharmacies?',
                style: NurtureBloomTextStyles.labelLg,
              ),
              const SizedBox(height: 4),
              Text(
                'We have mapped verified 24-hour chemists stocking infant rehydration, sterile water, and pump supplies.',
                style: NurtureBloomTextStyles.bodySm,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() => _activeFilter = 'pharmacy');
                  widget.onShowToast(
                    'Filtered Care Map to 24-hour verified chemists',
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: NurtureBloomColors.surfaceContainer,
                  foregroundColor: NurtureBloomColors.onSurface,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text('View Open Chemists'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapPin({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        boxShadow: NurtureBloomColors.ambientWarmShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: NurtureBloomTextStyles.labelSm.copyWith(
              color: NurtureBloomColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyGuidanceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _EmergencyGuidanceRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: NurtureBloomColors.tertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: NurtureBloomTextStyles.labelMd),
                Text(description, style: NurtureBloomTextStyles.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
