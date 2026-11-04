import 'package:flutter/material.dart';
import '../models/niamama_models.dart';
import '../theme/nurture_bloom_theme.dart';

class MotherAuthPinScreen extends StatefulWidget {
  final List<MotherTenantProfile> tenants;
  final MotherTenantProfile? lockedTenant;
  final void Function(
    MotherTenantProfile tenant, {
    required bool requirePinEveryTime,
  }) onAuthenticated;
  final void Function(MotherTenantProfile newTenant) onRegisterTenant;
  final VoidCallback? onSignOutSavedSession;

  const MotherAuthPinScreen({
    super.key,
    required this.tenants,
    this.lockedTenant,
    required this.onAuthenticated,
    required this.onRegisterTenant,
    this.onSignOutSavedSession,
  });

  @override
  State<MotherAuthPinScreen> createState() => _MotherAuthPinScreenState();
}

class _MotherAuthPinScreenState extends State<MotherAuthPinScreen> {
  // For PIN-only lock screen (when a session is already saved)
  String _enteredPin = '';
  late bool _requirePinEveryTime;

  // For blind Sign-In screen (no enumeration of other users)
  final TextEditingController _identifierCtrl = TextEditingController();
  final TextEditingController _loginPinCtrl = TextEditingController();
  bool _loginRequirePinEveryTime = false;

  // For New Mother Registration
  bool _isRegisteringNew = false;
  final TextEditingController _mamaNameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _babyNameCtrl = TextEditingController();
  final TextEditingController _babyWeeksCtrl =
      TextEditingController(text: '4');
  final TextEditingController _newPinCtrl = TextEditingController();
  bool _newTenantRequirePinEveryTime = false;

  String? _errorText;

  @override
  void initState() {
    super.initState();
    _requirePinEveryTime = widget.lockedTenant?.requirePinEveryTime ?? true;
  }

  @override
  void didUpdateWidget(covariant MotherAuthPinScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lockedTenant?.id != widget.lockedTenant?.id) {
      _enteredPin = '';
      _errorText = null;
      _requirePinEveryTime = widget.lockedTenant?.requirePinEveryTime ?? true;
    }
  }

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _loginPinCtrl.dispose();
    _mamaNameCtrl.dispose();
    _phoneCtrl.dispose();
    _babyNameCtrl.dispose();
    _babyWeeksCtrl.dispose();
    _newPinCtrl.dispose();
    super.dispose();
  }

  String _normalizePhone(String input) =>
      input.replaceAll(RegExp(r'[\s\-\(\)]'), '').toLowerCase();

  // Keypad handlers for locked session unlock
  void _onDigitPressed(String digit) {
    if (_enteredPin.length >= 4) return;
    setState(() {
      _enteredPin += digit;
      _errorText = null;
    });

    if (_enteredPin.length == 4) {
      _verifyLockedSessionPin();
    }
  }

  void _onBackspace() {
    if (_enteredPin.isEmpty) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _errorText = null;
    });
  }

  void _verifyLockedSessionPin() {
    final tenant = widget.lockedTenant;
    if (tenant == null) return;
    if (_enteredPin == tenant.pinCode) {
      widget.onAuthenticated(
        tenant,
        requirePinEveryTime: _requirePinEveryTime,
      );
    } else {
      setState(() {
        _enteredPin = '';
        _errorText = 'Incorrect 4-digit PIN. Please try again.';
      });
    }
  }

  // Blind sign-in handler: never reveals other accounts or whether an account exists
  void _submitBlindSignIn() {
    final rawId = _identifierCtrl.text.trim();
    final pin = _loginPinCtrl.text.trim();

    if (rawId.isEmpty || pin.length != 4) {
      setState(() {
        _errorText =
            'Please enter your registered phone number (or name) and 4-digit PIN.';
      });
      return;
    }

    final normInput = _normalizePhone(rawId);
    MotherTenantProfile? matched;
    for (final t in widget.tenants) {
      final normPhone = _normalizePhone(t.phone);
      final normName = t.mamaName.trim().toLowerCase();
      final normFirst = t.mamaFirstName.trim().toLowerCase();
      final idMatches = normPhone == normInput ||
          (normInput.length >= 6 && normPhone.endsWith(normInput)) ||
          normName == rawId.toLowerCase() ||
          normFirst == rawId.toLowerCase();

      if (idMatches && t.pinCode == pin) {
        matched = t;
        break;
      }
    }

    if (matched == null) {
      setState(() {
        _errorText =
            'Invalid phone number or 4-digit PIN. Please check and try again.';
      });
      return;
    }

    widget.onAuthenticated(
      matched,
      requirePinEveryTime: _loginRequirePinEveryTime,
    );
  }

  void _submitRegistration() {
    final mamaName = _mamaNameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final babyName = _babyNameCtrl.text.trim();
    final weeks = int.tryParse(_babyWeeksCtrl.text.trim()) ?? 4;
    final pin = _newPinCtrl.text.trim();

    if (mamaName.isEmpty || phone.isEmpty || babyName.isEmpty) {
      setState(() {
        _errorText =
            "Please enter your name, phone number, and your baby's name.";
      });
      return;
    }
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() {
        _errorText = 'Please set a 4-digit numeric PIN.';
      });
      return;
    }

    // Prevent duplicate phone collision without leaking other user details
    final normPhone = _normalizePhone(phone);
    final phoneExists = widget.tenants.any(
      (t) => _normalizePhone(t.phone) == normPhone,
    );
    if (phoneExists) {
      setState(() {
        _errorText =
            'Unable to register with this phone number. Please sign in or use a different number.';
      });
      return;
    }

    final now = DateTime.now();
    final dobDate = now.subtract(Duration(days: weeks * 7));
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dobFormatted =
        '${months[dobDate.month - 1]} ${dobDate.day}, ${dobDate.year}';
    final randSuffix = (now.millisecondsSinceEpoch % 90000 + 10000).toString();
    final initials = babyName.isNotEmpty
        ? babyName.substring(0, 1).toUpperCase()
        : 'B';

    final newTenant = MotherTenantProfile(
      id: 'tenant-${now.millisecondsSinceEpoch}',
      mamaName: mamaName,
      phone: phone,
      babyName: babyName,
      babyAgeWeeks: weeks.clamp(1, 104),
      babyDob: dobFormatted,
      whoPassId: '#WHO-$randSuffix-$initials',
      pinCode: pin,
      requirePinEveryTime: _newTenantRequirePinEveryTime,
      avatarColorHex: '#3E644A',
    );

    widget.onRegisterTenant(newTenant);
  }

  @override
  Widget build(BuildContext context) {
    final isLockedSessionMode =
        widget.lockedTenant != null && !_isRegisteringNew;

    return Scaffold(
      backgroundColor: NurtureBloomColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _isRegisteringNew
                  ? _buildRegisterCard()
                  : (isLockedSessionMode
                      ? _buildLockedSessionPinCard(widget.lockedTenant!)
                      : _buildPrivateSignInCard()),
            ),
          ),
        ),
      ),
    );
  }

  /// Shown when a mother is already logged in on this device and has PIN-on-every-access enabled.
  Widget _buildLockedSessionPinCard(MotherTenantProfile lockedTenant) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: NurtureBloomColors.primaryFixed,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_rounded,
                size: 16,
                color: NurtureBloomColors.onPrimaryFixed,
              ),
              const SizedBox(width: 6),
              Text(
                'Private Maternal Vault Locked',
                style: NurtureBloomTextStyles.labelSm.copyWith(
                  color: NurtureBloomColors.onPrimaryFixed,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Welcome back, ${lockedTenant.mamaFirstName}',
          style: NurtureBloomTextStyles.headlineLgMobile,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Enter your 4-digit PIN to unlock your session.',
          style: NurtureBloomTextStyles.bodySm,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: NurtureBloomColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            boxShadow: NurtureBloomColors.ambientWarmShadow,
          ),
          child: Column(
            children: [
              // 4 PIN Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: isFilled
                          ? NurtureBloomColors.primary
                          : NurtureBloomColors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isFilled
                            ? NurtureBloomColors.primary
                            : NurtureBloomColors.outlineVariant,
                        width: 1.5,
                      ),
                    ),
                  );
                }),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorText!,
                  style: NurtureBloomTextStyles.labelSm.copyWith(
                    color: NurtureBloomColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),

              // Toggle whether PIN is required on every access
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: NurtureBloomColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      _requirePinEveryTime
                          ? Icons.pin_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 20,
                      color: NurtureBloomColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ask for PIN every time',
                            style: NurtureBloomTextStyles.labelMd,
                          ),
                          Text(
                            _requirePinEveryTime
                                ? 'Required on every app access'
                                : 'Keep session unlocked next time',
                            style: NurtureBloomTextStyles.bodySm.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _requirePinEveryTime,
                      activeThumbColor: NurtureBloomColors.primary,
                      onChanged: (val) =>
                          setState(() => _requirePinEveryTime = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildKeypad(),
            ],
          ),
        ),
        if (widget.onSignOutSavedSession != null) ...[
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: widget.onSignOutSavedSession,
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Sign Out of This Session'),
          ),
        ],
      ],
    );
  }

  /// Blind Sign-In Card: Never displays other accounts or user count.
  Widget _buildPrivateSignInCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: NurtureBloomColors.ambientWarmShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: NurtureBloomColors.primaryFixed,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shield_rounded,
                  size: 15,
                  color: NurtureBloomColors.onPrimaryFixed,
                ),
                const SizedBox(width: 6),
                Text(
                  'Private Maternal Companion',
                  style: NurtureBloomTextStyles.labelSm.copyWith(
                    color: NurtureBloomColors.onPrimaryFixed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Sign In to Your Vault',
            style: NurtureBloomTextStyles.headlineLgMobile,
          ),
          const SizedBox(height: 4),
          Text(
            'Enter your phone number and 4-digit PIN. Your session will be saved on this device.',
            style: NurtureBloomTextStyles.bodySm,
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _identifierCtrl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Phone Number or Registered Name',
              prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20),
              filled: true,
              fillColor: NurtureBloomColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _loginPinCtrl,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '4-Digit PIN',
              counterText: '',
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              filled: true,
              fillColor: NurtureBloomColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.pin_rounded,
                  size: 20,
                  color: NurtureBloomColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Require PIN on every access',
                        style: NurtureBloomTextStyles.labelMd,
                      ),
                      Text(
                        _loginRequirePinEveryTime
                            ? 'Ask for PIN every time I open Niamama'
                            : 'Save my session (open directly next time)',
                        style: NurtureBloomTextStyles.bodySm.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _loginRequirePinEveryTime,
                  activeThumbColor: NurtureBloomColors.primary,
                  onChanged: (val) =>
                      setState(() => _loginRequirePinEveryTime = val),
                ),
              ],
            ),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 10),
            Text(
              _errorText!,
              style: NurtureBloomTextStyles.labelSm.copyWith(
                color: NurtureBloomColors.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submitBlindSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: NurtureBloomColors.primary,
                foregroundColor: NurtureBloomColors.onPrimary,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              icon: const Icon(Icons.login_rounded, size: 18),
              label: const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _isRegisteringNew = true;
                  _errorText = null;
                });
              },
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('New Mother? Create Your Private Account'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['CLEAR', '0', 'BACK'],
    ];

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key == 'CLEAR') {
                return _buildKeypadButton(
                  child: Text(
                    'Clear',
                    style: NurtureBloomTextStyles.labelSm,
                  ),
                  onTap: () => setState(() {
                    _enteredPin = '';
                    _errorText = null;
                  }),
                );
              }
              if (key == 'BACK') {
                return _buildKeypadButton(
                  child: const Icon(
                    Icons.backspace_outlined,
                    size: 20,
                    color: NurtureBloomColors.onSurface,
                  ),
                  onTap: _onBackspace,
                );
              }
              return _buildKeypadButton(
                child: Text(
                  key,
                  style: NurtureBloomTextStyles.headlineMd,
                ),
                onTap: () => _onDigitPressed(key),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeypadButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 78,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: NurtureBloomColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: child,
      ),
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NurtureBloomColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: NurtureBloomColors.ambientWarmShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create Private Account',
                style: NurtureBloomTextStyles.headlineMd,
              ),
              IconButton(
                onPressed: () => setState(() {
                  _isRegisteringNew = false;
                  _errorText = null;
                }),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          Text(
            'Set up your personal maternal & infant care companion.',
            style: NurtureBloomTextStyles.bodySm,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _mamaNameCtrl,
            decoration: InputDecoration(
              labelText: "Your Full Name",
              filled: true,
              fillColor: NurtureBloomColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              filled: true,
              fillColor: NurtureBloomColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _babyNameCtrl,
                  decoration: InputDecoration(
                    labelText: "Baby's First Name",
                    filled: true,
                    fillColor: NurtureBloomColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _babyWeeksCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weeks Old',
                    filled: true,
                    fillColor: NurtureBloomColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _newPinCtrl,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Set 4-Digit Security PIN',
              counterText: '',
              filled: true,
              fillColor: NurtureBloomColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: NurtureBloomColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_clock_rounded,
                  size: 20,
                  color: NurtureBloomColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Require PIN every time I open app',
                        style: NurtureBloomTextStyles.labelMd,
                      ),
                      Text(
                        _newTenantRequirePinEveryTime
                            ? 'Ask for PIN on every access'
                            : 'Keep session logged in automatically',
                        style: NurtureBloomTextStyles.bodySm.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _newTenantRequirePinEveryTime,
                  activeThumbColor: NurtureBloomColors.primary,
                  onChanged: (val) =>
                      setState(() => _newTenantRequirePinEveryTime = val),
                ),
              ],
            ),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorText!,
              style: NurtureBloomTextStyles.labelSm.copyWith(
                color: NurtureBloomColors.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: NurtureBloomColors.primary,
                foregroundColor: NurtureBloomColors.onPrimary,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.check_circle_rounded, size: 18),
              label: const Text('Create Account & Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}
