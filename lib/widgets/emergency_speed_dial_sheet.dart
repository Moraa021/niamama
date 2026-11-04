import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../services/location_service.dart';
import '../theme/nurture_bloom_theme.dart';

class EmergencySpeedDialSheet extends StatefulWidget {
  final List<EmergencyContact> contacts;
  final UserCoordinates userCoords;
  final GpsPermissionStatus gpsStatus;
  final VoidCallback onRequestLocation;
  final void Function(EmergencyContact newContact) onAddContact;
  final void Function(String contactId) onDeleteContact;
  final void Function(String message) onShowToast;

  const EmergencySpeedDialSheet({
    super.key,
    required this.contacts,
    required this.userCoords,
    required this.gpsStatus,
    required this.onRequestLocation,
    required this.onAddContact,
    required this.onDeleteContact,
    required this.onShowToast,
  });

  @override
  State<EmergencySpeedDialSheet> createState() =>
      _EmergencySpeedDialSheetState();
}

class _EmergencySpeedDialSheetState extends State<EmergencySpeedDialSheet> {
  bool _showAddForm = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController =
      TextEditingController(text: 'Emergency Contact');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _saveNewContact() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final role = _roleController.text.trim();
    if (name.isEmpty || phone.isEmpty) return;

    final newContact = EmergencyContact(
      id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      role: role.isEmpty ? 'Support Circle' : role,
      subtitle: '${role.isEmpty ? "Emergency" : role} • Speed-Dial Ready',
      phone: phone,
      badgeType: 'tertiary',
      isCustom: true,
    );
    widget.onAddContact(newContact);
    widget.onShowToast('Added $name to offline emergency speed-dial');
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _showAddForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryPartner =
        widget.contacts.isNotEmpty ? widget.contacts.first : null;

    return Container(
      decoration: const BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: NurtureBloomColors.tertiaryFixed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emergency_rounded,
                        color: NurtureBloomColors.tertiary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Speed-Dial',
                          style: NurtureBloomTextStyles.headlineSm,
                        ),
                        Text(
                          'Works 100% Offline • One-Tap Call & GPS SOS',
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            color: NurtureBloomColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: NurtureBloomColors.surfaceContainerLow,
                  ),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: NurtureBloomColors.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Live GPS Coordinate Broadcast Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NurtureBloomColors.secondaryFixed.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: widget.userCoords.isLiveGps
                                  ? NurtureBloomColors.primary
                                  : NurtureBloomColors.tertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.userCoords.isLiveGps
                                ? 'Live GPS Locked (±${widget.userCoords.accuracy.round()}m)'
                                : 'Offline / Cached Area',
                            style: NurtureBloomTextStyles.labelSm.copyWith(
                              color: NurtureBloomColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      if (widget.gpsStatus != GpsPermissionStatus.granted)
                        GestureDetector(
                          onTap: widget.onRequestLocation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: NurtureBloomColors.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Enable Live GPS',
                              style: NurtureBloomTextStyles.labelSm.copyWith(
                                color: NurtureBloomColors.onPrimary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.userCoords.areaName} (${widget.userCoords.lat.toStringAsFixed(4)}°, ${widget.userCoords.lng.toStringAsFixed(4)}°)',
                    style: NurtureBloomTextStyles.bodySm,
                  ),
                  if (primaryPartner != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          LocationService.sendEmergencyGpsSms(
                            phoneNumber: primaryPartner.phone,
                            coords: widget.userCoords,
                            isUrgentSos: true,
                          );
                          widget.onShowToast(
                            'Prepared SOS SMS with live GPS pin for ${primaryPartner.name}',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              NurtureBloomColors.surfaceContainerLowest,
                          foregroundColor: NurtureBloomColors.tertiary,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(Icons.share_location_rounded, size: 18),
                        label: Text(
                          'Text My Live GPS to ${primaryPartner.name.split(" ").first}',
                          style: NurtureBloomTextStyles.labelMd.copyWith(
                            color: NurtureBloomColors.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 24/7 National & Hospital Hotlines
            Text(
              '24/7 IMMEDIATE TRIAGE & DISPATCH',
              style: NurtureBloomTextStyles.labelSm.copyWith(
                color: NurtureBloomColors.secondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            // 1190 National Maternal Helpline
            InkWell(
              onTap: () {
                LocationService.dialNumber('1190');
                widget.onShowToast(
                  'Dialing 1190 — 24/7 National Maternal Helpline...',
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.tertiary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_in_talk_rounded,
                          color: NurtureBloomColors.onTertiary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'National Maternal Helpline',
                              style: NurtureBloomTextStyles.labelLg.copyWith(
                                color: NurtureBloomColors.onTertiary,
                              ),
                            ),
                            Text(
                              'Toll-Free 1190 • 24/7 Midwife & Ambulance',
                              style: NurtureBloomTextStyles.labelSm.copyWith(
                                color: NurtureBloomColors.onTertiary
                                    .withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '1190',
                        style: NurtureBloomTextStyles.labelSm.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      LocationService.dialNumber('0800720000');
                      widget.onShowToast(
                        'Dialing Sub-County ER Maternity Triage Desk...',
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NurtureBloomColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.local_hospital_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '24/7 ER',
                                  style:
                                      NurtureBloomTextStyles.labelSm.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hospital Triage',
                            style: NurtureBloomTextStyles.labelMd.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Sub-County Referral',
                            style: NurtureBloomTextStyles.labelSm.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      LocationService.dialNumber('999');
                      widget.onShowToast(
                        'Dialing 999 Emergency Ambulance Dispatch...',
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NurtureBloomColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.medical_services_rounded,
                                color: NurtureBloomColors.tertiary,
                                size: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '999 / 112',
                                  style: NurtureBloomTextStyles.labelSm,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ambulance SOS',
                            style: NurtureBloomTextStyles.labelMd,
                          ),
                          Text(
                            'Emergency Paramedics',
                            style: NurtureBloomTextStyles.labelSm,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Trusted Circle Speed-Dial Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TRUSTED CIRCLE SPEED-DIAL (${widget.contacts.length})',
                  style: NurtureBloomTextStyles.labelSm.copyWith(
                    color: NurtureBloomColors.secondary,
                    letterSpacing: 0.6,
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => _showAddForm = !_showAddForm),
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                  label: Text(
                    _showAddForm ? 'Close' : 'Add Contact',
                    style: NurtureBloomTextStyles.labelSm.copyWith(
                      color: NurtureBloomColors.primary,
                    ),
                  ),
                ),
              ],
            ),

            // Add Custom Speed-Dial Form
            if (_showAddForm)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Offline Speed-Dial Contact',
                      style: NurtureBloomTextStyles.labelMd,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name (e.g., Sister Mary or Clinic)',
                        filled: true,
                        fillColor: NurtureBloomColors.surfaceContainerLowest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone (+2547...)',
                              filled: true,
                              fillColor:
                                  NurtureBloomColors.surfaceContainerLowest,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _roleController,
                            decoration: InputDecoration(
                              hintText: 'Role (e.g., Family)',
                              filled: true,
                              fillColor:
                                  NurtureBloomColors.surfaceContainerLowest,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: _saveNewContact,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NurtureBloomColors.primary,
                          foregroundColor: NurtureBloomColors.onPrimary,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Save to Speed-Dial'),
                      ),
                    ),
                  ],
                ),
              ),

            // Speed-Dial Contact Rows
            ...widget.contacts.map((contact) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: NurtureBloomColors.primaryFixed,
                            backgroundImage: contact.avatarUrl != null
                                ? NetworkImage(contact.avatarUrl!)
                                : null,
                            child: contact.avatarUrl == null
                                ? Text(
                                    contact.name.characters.first.toUpperCase(),
                                    style: NurtureBloomTextStyles.headlineSm
                                        .copyWith(
                                      color: NurtureBloomColors.onPrimaryFixed,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.name,
                                  style: NurtureBloomTextStyles.labelLg,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${contact.phone} • ${contact.role}',
                                  style: NurtureBloomTextStyles.bodySm,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            LocationService.dialNumber(contact.phone);
                            widget.onShowToast('Calling ${contact.name}...');
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: NurtureBloomColors.primary,
                            foregroundColor: NurtureBloomColors.onPrimary,
                          ),
                          icon: const Icon(Icons.call_rounded, size: 18),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () {
                            LocationService.sendEmergencyGpsSms(
                              phoneNumber: contact.phone,
                              coords: widget.userCoords,
                              isUrgentSos: true,
                            );
                            widget.onShowToast(
                              'Sending SOS + GPS coordinates to ${contact.name}...',
                            );
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: NurtureBloomColors.secondaryFixed,
                            foregroundColor:
                                NurtureBloomColors.onSecondaryFixed,
                          ),
                          icon: const Icon(Icons.sms_rounded, size: 18),
                        ),
                        if (contact.isCustom) ...[
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: () =>
                                widget.onDeleteContact(contact.id),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: NurtureBloomColors.outline,
                              size: 18,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
