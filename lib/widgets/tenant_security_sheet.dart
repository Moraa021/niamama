import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../theme/nurture_bloom_theme.dart';

class TenantSecuritySheet extends StatefulWidget {
  final MotherTenantProfile activeTenant;
  final void Function(MotherTenantProfile updated) onUpdateActiveTenant;
  final VoidCallback onLockNow;
  final VoidCallback onSignOut;
  final void Function(String message) onShowToast;

  const TenantSecuritySheet({
    super.key,
    required this.activeTenant,
    required this.onUpdateActiveTenant,
    required this.onLockNow,
    required this.onSignOut,
    required this.onShowToast,
  });

  @override
  State<TenantSecuritySheet> createState() => _TenantSecuritySheetState();
}

class _TenantSecuritySheetState extends State<TenantSecuritySheet> {
  late bool _requirePinEveryTime;
  bool _isEditingPin = false;
  final TextEditingController _newPinController = TextEditingController();
  String? _pinError;

  @override
  void initState() {
    super.initState();
    _requirePinEveryTime = widget.activeTenant.requirePinEveryTime;
  }

  @override
  void dispose() {
    _newPinController.dispose();
    super.dispose();
  }

  void _toggleRequirePin(bool value) {
    setState(() => _requirePinEveryTime = value);
    final updated = widget.activeTenant.copyWith(requirePinEveryTime: value);
    widget.onUpdateActiveTenant(updated);
    widget.onShowToast(
      value
          ? 'Security updated: PIN required every time you access Niamama'
          : 'Session saved: Auto-login enabled for ${widget.activeTenant.mamaFirstName}',
    );
  }

  void _saveNewPin() {
    final pin = _newPinController.text.trim();
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() => _pinError = 'Please enter a valid 4-digit numeric PIN');
      return;
    }
    final updated = widget.activeTenant.copyWith(pinCode: pin);
    widget.onUpdateActiveTenant(updated);
    setState(() {
      _isEditingPin = false;
      _pinError = null;
      _newPinController.clear();
    });
    widget.onShowToast(
      '4-digit PIN updated for ${widget.activeTenant.mamaFirstName}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final tenant = widget.activeTenant;

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
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: NurtureBloomColors.primaryFixed,
                      child: Text(
                        tenant.initials,
                        style: NurtureBloomTextStyles.labelLg.copyWith(
                          color: NurtureBloomColors.onPrimaryFixed,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant.mamaName,
                          style: NurtureBloomTextStyles.headlineSm,
                        ),
                        Text(
                          'Baby ${tenant.babyName} (${tenant.babyAgeWeeks}w) • ${tenant.whoPassId}',
                          style: NurtureBloomTextStyles.labelSm.copyWith(
                            color: NurtureBloomColors.primary,
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
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Private Maternal Vault badge
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NurtureBloomColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NurtureBloomColors.outlineVariant),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield_rounded,
                    color: NurtureBloomColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Private Maternal Vault',
                          style: NurtureBloomTextStyles.labelMd,
                        ),
                        Text(
                          'Your nursing logs, vaccines, calendar reminders, emergency speed-dial contacts, and midwife chats are stored privately in your personal encrypted session.',
                          style: NurtureBloomTextStyles.bodySm.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Session Persistence & PIN Requirement Toggle
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NurtureBloomColors.secondaryContainer
                    .withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _requirePinEveryTime
                            ? Icons.lock_rounded
                            : Icons.verified_user_rounded,
                        color: NurtureBloomColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Require PIN on Every Access',
                              style: NurtureBloomTextStyles.labelLg,
                            ),
                            Text(
                              _requirePinEveryTime
                                  ? 'ON: You will be asked for your 4-digit PIN every time you open or resume Niamama.'
                                  : 'OFF: Your login session stays saved so you open straight to your dashboard.',
                              style: NurtureBloomTextStyles.bodySm.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _requirePinEveryTime,
                        activeThumbColor: NurtureBloomColors.primary,
                        onChanged: _toggleRequirePin,
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Personal 4-Digit PIN: ••••',
                        style: NurtureBloomTextStyles.labelSm,
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            setState(() => _isEditingPin = !_isEditingPin),
                        icon: const Icon(Icons.edit_rounded, size: 16),
                        label: Text(_isEditingPin ? 'Cancel' : 'Change PIN'),
                      ),
                    ],
                  ),
                  if (_isEditingPin) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newPinController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'New 4-digit PIN',
                              counterText: '',
                              errorText: _pinError,
                              filled: true,
                              fillColor:
                                  NurtureBloomColors.surfaceContainerLowest,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _saveNewPin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NurtureBloomColors.primary,
                            foregroundColor: NurtureBloomColors.onPrimary,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Save PIN'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions: Lock Now & Sign Out
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onLockNow();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.lock_outline_rounded, size: 18),
                    label: const Text('Lock Vault Now'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSignOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NurtureBloomColors.primary,
                      foregroundColor: NurtureBloomColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
