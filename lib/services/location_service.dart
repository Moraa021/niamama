import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/niamama_models.dart';

enum GpsPermissionStatus {
  prompt,
  requesting,
  granted,
  denied,
  disabled,
}

class LocationService {
  static const List<CareFacility> facilities = [
    CareFacility(
      id: 'sub-county-referral',
      name: 'Sub-County Referral Hospital',
      badgeText: 'Primary & Nearest',
      secondaryBadge: 'Level 4 Hospital',
      isPrimaryVariant: true,
      lat: -1.2955,
      lng: 36.8025,
      phone: '0800720000',
      isWalkingMode: false,
      statusHeadline: 'Low Wait Time • Midwife on Duty',
      statusSubtext: 'Avg: ~10 mins',
      isLivePing: true,
      capabilities: [
        'Cold-Chain Verified',
        'NICU & Maternity Wing',
        'Midwife Triage Desk',
      ],
      tags: ['maternity', 'vaccines', 'midwife', 'pediatric'],
      icon: Icons.domain_rounded,
      primaryCtaLabel: 'Call Triage Hotline',
      secondaryCtaLabel: 'Get Directions (Maps)',
    ),
    CareFacility(
      id: 'st-jude-center',
      name: 'St. Jude Mother & Child Center',
      badgeText: 'Mother & Child Specialty',
      isPrimaryVariant: false,
      lat: -1.2812,
      lng: 36.7918,
      phone: '0800720002',
      isWalkingMode: false,
      statusHeadline: 'Open until 8:00 PM',
      statusSubtext: 'On-call Pediatrician',
      isLivePing: false,
      capabilities: [
        'Pediatric Emergency',
        'Lactation Consultation',
        'Private Suites',
      ],
      tags: ['maternity', 'pediatric'],
      icon: Icons.medical_services_rounded,
      primaryCtaLabel: 'Call Reception',
      secondaryCtaLabel: 'Directions',
    ),
    CareFacility(
      id: 'community-post-welfare',
      name: 'Community Post & Child Welfare',
      badgeText: 'Public Clinic',
      isPrimaryVariant: true,
      lat: -1.3095,
      lng: 36.8212,
      phone: '0800720010',
      isWalkingMode: true,
      statusHeadline: 'Walk-ins Welcome (8 AM - 4 PM)',
      statusSubtext: 'No Booking Required',
      isLivePing: false,
      capabilities: [
        'Free WHO Routine Vaccines',
        'Well-Baby Checkups',
        'Nutritional Weighing',
      ],
      tags: ['vaccines', 'midwife'],
      icon: Icons.vaccines_rounded,
      primaryCtaLabel: 'Call Clinic',
      secondaryCtaLabel: 'Start Walking Route',
    ),
    CareFacility(
      id: 'greenleaf-chemist',
      name: 'GreenLeaf 24-Hr Maternal Chemist',
      badgeText: '24/7 Pharmacy',
      isPrimaryVariant: true,
      lat: -1.3012,
      lng: 36.8115,
      phone: '0800720055',
      isWalkingMode: false,
      statusHeadline: 'Open 24 Hours • Pharmacist On-Site',
      statusSubtext: 'Infant ORS & Sterile Supplies',
      isLivePing: true,
      capabilities: [
        'Infant Rehydration ORS',
        'Breast Pump & Sterile Water',
      ],
      tags: ['pharmacy'],
      icon: Icons.local_pharmacy_rounded,
      primaryCtaLabel: 'Call Pharmacist',
      secondaryCtaLabel: 'Directions',
    ),
  ];

  /// Requests native OS location permission and fetches live GPS coordinates.
  static Future<({GpsPermissionStatus status, UserCoordinates? coords})>
      requestLiveLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return (status: GpsPermissionStatus.disabled, coords: null);
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return (status: GpsPermissionStatus.denied, coords: null);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return (status: GpsPermissionStatus.denied, coords: null);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final coords = UserCoordinates(
        lat: position.latitude,
        lng: position.longitude,
        accuracy: position.accuracy,
        areaName:
            'Live GPS (${position.latitude.toStringAsFixed(3)}°, ${position.longitude.toStringAsFixed(3)}°)',
        isLiveGps: true,
      );
      return (status: GpsPermissionStatus.granted, coords: coords);
    } catch (_) {
      return (status: GpsPermissionStatus.prompt, coords: null);
    }
  }

  /// Calculates Haversine distance in kilometers between two coordinates.
  static double calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _degToRad(lat2 - lat1);
    final double dLon = _degToRad(lon2 - lon1);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(lat1)) *
            math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double km = earthRadiusKm * c;
    return (km * 10).roundToDouble() / 10;
  }

  static int estimateTravelMinutes(double distanceKm, bool isWalking) {
    if (isWalking) {
      return math.max(2, ((distanceKm / 4.8) * 60).round());
    }
    return math.max(3, ((distanceKm / 22.0) * 60).round());
  }

  static double _degToRad(double deg) => deg * (math.pi / 180.0);

  /// Launches native phone dialer (`tel:`).
  static Future<void> dialNumber(String phoneNumber) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: clean);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Launches native SMS app (`sms:`) pre-filled with live GPS coordinates.
  static Future<void> sendEmergencyGpsSms({
    required String phoneNumber,
    required UserCoordinates coords,
    required bool isUrgentSos,
  }) async {
    final clean = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final mapsLink =
        'https://maps.google.com/?q=${coords.lat.toStringAsFixed(5)},${coords.lng.toStringAsFixed(5)}';
    final body = isUrgentSos
        ? 'URGENT SOS from Niamama: Mama & Baby Leo need assistance. Location (${coords.areaName}): $mapsLink'
        : 'Hi from Niamama: Checking in with Baby Leo. Our location (${coords.areaName}): $mapsLink';

    final uri = Uri(
      scheme: 'sms',
      path: clean,
      queryParameters: <String, String>{'body': body},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Opens native Google Maps / Apple Maps turn-by-turn directions.
  static Future<void> openDirections({
    required UserCoordinates userCoords,
    required double destLat,
    required double destLng,
    required bool isWalking,
  }) async {
    final mode = isWalking ? 'walking' : 'driving';
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=${userCoords.lat},${userCoords.lng}&destination=$destLat,$destLng&travelmode=$mode',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
