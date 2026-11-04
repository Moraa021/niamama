import 'package:flutter/material.dart';
import 'models/niamama_models.dart';
import 'screens/care_map_screen.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/mother_auth_pin_screen.dart';
import 'screens/support_circle_screen.dart';
import 'screens/timeline_vaccines_screen.dart';
import 'services/location_service.dart';
import 'services/neo4j_knowledge_service.dart';
import 'services/offline_vault_service.dart';
import 'theme/nurture_bloom_theme.dart';
import 'widgets/calendar_reminder_sheet.dart';
import 'widgets/clinical_triage_and_guide_sheet.dart';
import 'widgets/emergency_speed_dial_sheet.dart';
import 'widgets/midwife_safe_chat_sheet.dart';
import 'widgets/tenant_security_sheet.dart';
import 'widgets/who_digital_pass_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NiamamaApp());
}

class NiamamaApp extends StatelessWidget {
  const NiamamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niamama — Postpartum & Infant Care Companion',
      debugShowCheckedModeBanner: false,
      theme: NurtureBloomTheme.lightTheme,
      home: const NiamamaShellScreen(),
    );
  }
}

class NiamamaShellScreen extends StatefulWidget {
  const NiamamaShellScreen({super.key});

  @override
  State<NiamamaShellScreen> createState() => _NiamamaShellScreenState();
}

class _NiamamaShellScreenState extends State<NiamamaShellScreen>
    with WidgetsBindingObserver {
  static const String _logoUrl =
      'https://lh3.googleusercontent.com/aida/AEtjO1WqHNrL4Nuwb7bdQrcOaBf2upeNg7-OyQmTnmF4weODe9PZLWXX80zhcBB-huOLtxByiEk4AK0YgJ4FMAjFrThVFan98pFy277_JU9zSuDur4hWWDKsYes4HsHl8pJe29kvVUUxYGAtRS5HkONqcMviq2-rBYY4ldsMXyvn1VMFHrmWN4r8_qm8c9VqO1Zxh0tNhEDqHJxePmC5ffsyVx8uRy4hua2wplKaUuiTRun_';

  int _activeTabIndex = 0;
  List<MotherTenantProfile> _tenants = List<MotherTenantProfile>.from(
    MotherTenantProfile.defaultTenants,
  );
  MotherTenantProfile _activeTenant = MotherTenantProfile.defaultTenants.first;
  bool _isPinLocked = false;
  bool _isMultiTenantSelectorOpen = false;

  NiamamaState _state = NiamamaState.initial(
    tenant: MotherTenantProfile.defaultTenants.first,
  );
  UserCoordinates _userCoords = UserCoordinates.defaultNairobiWest;
  GpsPermissionStatus _gpsStatus = GpsPermissionStatus.prompt;
  Neo4jGraphStatus _graphStatus = Neo4jGraphStatus.defaultOffline;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeOfflineVault();
    _syncNeo4jGraph();
  }

  Future<void> _syncNeo4jGraph({bool showNotification = false}) async {
    final status = await Neo4jKnowledgeGraphService.connectAndSeedGraph();
    if (!mounted) return;
    setState(() => _graphStatus = status);
    if (showNotification) {
      _showToast(status.statusLabel);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the active mother enabled "Require PIN every time", lock on backgrounding/resuming
    if (state == AppLifecycleState.paused &&
        _activeTenant.requirePinEveryTime) {
      setState(() {
        _isPinLocked = true;
      });
    }
  }

  Future<void> _initializeOfflineVault() async {
    final loadedTenants = await OfflineVaultService.loadTenants();
    final savedSessionTenantId =
        await OfflineVaultService.loadActiveSessionTenantId();

    MotherTenantProfile selected = loadedTenants.first;
    if (savedSessionTenantId != null) {
      final match =
          loadedTenants.where((t) => t.id == savedSessionTenantId).toList();
      if (match.isNotEmpty) {
        selected = match.first;
      }
    } else {
      // Persist the primary session on initial install so the mother stays logged in
      await OfflineVaultService.saveActiveSessionTenantId(selected.id);
    }

    final loadedState = await OfflineVaultService.loadState(tenant: selected);
    if (!mounted) return;
    setState(() {
      _tenants = loadedTenants;
      _activeTenant = selected;
      // Enforce PIN lock on startup if the mother enabled "Require PIN on every access"
      _isPinLocked = selected.requirePinEveryTime;
      _state = loadedState;
      _userCoords =
          loadedState.cachedCoordinates ?? UserCoordinates.defaultNairobiWest;
    });
  }

  Future<void> _updateState(NiamamaState next) async {
    setState(() => _state = next);
    await OfflineVaultService.saveState(next, tenantId: _activeTenant.id);
  }

  Future<void> _updateActiveTenantProfile(MotherTenantProfile updated) async {
    final nextTenants = _tenants
        .map((t) => t.id == updated.id ? updated : t)
        .toList();
    setState(() {
      _activeTenant = updated;
      _tenants = nextTenants;
    });
    await OfflineVaultService.saveTenants(nextTenants);
  }

  Future<void> _handleAuthenticatedTenant(
    MotherTenantProfile tenant, {
    required bool requirePinEveryTime,
  }) async {
    final updatedTenant = tenant.copyWith(
      requirePinEveryTime: requirePinEveryTime,
    );
    final nextTenants = _tenants
        .map((t) => t.id == updatedTenant.id ? updatedTenant : t)
        .toList();

    await OfflineVaultService.saveTenants(nextTenants);
    await OfflineVaultService.saveActiveSessionTenantId(updatedTenant.id);
    final tenantState = await OfflineVaultService.loadState(
      tenant: updatedTenant,
    );

    if (!mounted) return;
    setState(() {
      _tenants = nextTenants;
      _activeTenant = updatedTenant;
      _state = tenantState;
      _userCoords =
          tenantState.cachedCoordinates ?? UserCoordinates.defaultNairobiWest;
      _isPinLocked = false;
      _isMultiTenantSelectorOpen = false;
      _activeTabIndex = 0;
    });

    _showToast(
      requirePinEveryTime
          ? 'Unlocked ${updatedTenant.mamaFirstName}\'s vault • PIN required every access'
          : 'Welcome ${updatedTenant.mamaFirstName} • Session saved (auto-login active)',
    );
  }

  Future<void> _handleRegisterNewTenant(MotherTenantProfile newTenant) async {
    final nextTenants = [..._tenants, newTenant];
    final freshState = NiamamaState.initial(tenant: newTenant);
    await OfflineVaultService.saveTenants(nextTenants);
    await OfflineVaultService.saveState(freshState, tenantId: newTenant.id);
    await OfflineVaultService.saveActiveSessionTenantId(newTenant.id);

    if (!mounted) return;
    setState(() {
      _tenants = nextTenants;
      _activeTenant = newTenant;
      _state = freshState;
      _userCoords = UserCoordinates.defaultNairobiWest;
      _isPinLocked = false;
      _isMultiTenantSelectorOpen = false;
      _activeTabIndex = 0;
    });

    _showToast(
      'Created isolated vault for ${newTenant.mamaName} & Baby ${newTenant.babyName}',
    );
  }

  void _openTenantSecuritySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TenantSecuritySheet(
        activeTenant: _activeTenant,
        onUpdateActiveTenant: _updateActiveTenantProfile,
        onLockNow: () {
          setState(() {
            _isPinLocked = true;
            _isMultiTenantSelectorOpen = false;
          });
        },
        onSignOut: () async {
          await OfflineVaultService.saveActiveSessionTenantId(null);
          if (!mounted) return;
          setState(() {
            _isMultiTenantSelectorOpen = true;
            _isPinLocked = false;
          });
        },
        onShowToast: _showToast,
      ),
    );
  }

  void _showToast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: NurtureBloomColors.inverseSurface,
          shape: const StadiumBorder(),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: NurtureBloomColors.primaryFixed,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: NurtureBloomTextStyles.labelSm.copyWith(
                    color: NurtureBloomColors.inverseOnSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _requestLiveLocation() async {
    setState(() => _gpsStatus = GpsPermissionStatus.requesting);
    final result = await LocationService.requestLiveLocation();
    if (!mounted) return;

    setState(() {
      _gpsStatus = result.status;
      if (result.coords != null) {
        _userCoords = result.coords!;
      }
    });

    if (result.coords != null) {
      await _updateState(_state.copyWith(cachedCoordinates: result.coords));
      _showToast('Live GPS locked • Facility distances updated');
    } else if (result.status == GpsPermissionStatus.denied) {
      _showToast('Location permission denied • Using cached coordinates');
    } else {
      _showToast('Using offline cached location (${_userCoords.areaName})');
    }
  }

  void _openEmergencySpeedDial() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EmergencySpeedDialSheet(
        contacts: _state.contacts,
        userCoords: _userCoords,
        gpsStatus: _gpsStatus,
        onRequestLocation: _requestLiveLocation,
        onAddContact: (newContact) {
          _updateState(
            _state.copyWith(contacts: [newContact, ..._state.contacts]),
          );
        },
        onDeleteContact: (id) {
          _updateState(
            _state.copyWith(
              contacts: _state.contacts.where((c) => c.id != id).toList(),
            ),
          );
          _showToast('Removed speed-dial contact');
        },
        onShowToast: _showToast,
      ),
    );
  }

  void _openCalendarReminder(CalendarReminderTarget target) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CalendarReminderSheet(
        target: target,
        onSaved: (reminderId, formattedDate) {
          final updated = Map<String, String>.from(
            _state.savedCalendarReminders,
          )..[reminderId] = formattedDate;
          _updateState(_state.copyWith(savedCalendarReminders: updated));
        },
        onShowToast: _showToast,
      ),
    );
  }

  void _openWhoDigitalPass() {
    showDialog(
      context: context,
      builder: (ctx) => WhoDigitalPassDialog(
        tenant: _activeTenant,
        completedVaccines: _state.completedVaccines,
        onShowToast: _showToast,
      ),
    );
  }

  void _openSafeChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MidwifeSafeChatSheet(
        messages: _state.chatMessages,
        onSendMessage: (topics, text) async {
          final mamaMessage = ChatMessage(
            id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
            isFromMama: true,
            text: text.isNotEmpty
                ? text
                : 'Requesting guidance on: ${topics.join(", ")}',
            timestamp: DateTime.now(),
          );

          final grounded =
              await Neo4jKnowledgeGraphService.queryGroundedMidwifeGuidance(
            topics: topics,
            userText: text,
            mamaFirstName: _activeTenant.mamaFirstName,
            babyName: _activeTenant.babyName,
          );

          final midwifeReply = ChatMessage(
            id: 'msg-reply-${DateTime.now().millisecondsSinceEpoch + 1}',
            isFromMama: false,
            text: grounded.replyText,
            timestamp: DateTime.now(),
          );
          await _updateState(
            _state.copyWith(
              chatMessages: [
                ..._state.chatMessages,
                mamaMessage,
                midwifeReply,
              ],
            ),
          );
          _showToast(
            grounded.fromLiveNeo4j
                ? 'Neo4j Grounded Reply • Midwife Sarah responded'
                : 'Offline Graph Grounded Reply • Midwife Sarah responded',
          );
        },
      ),
    );
  }

  void _openClinicalTriage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Neo4jClinicalTriageSheet(
        graphStatus: _graphStatus,
        onRefreshGraph: () => _syncNeo4jGraph(showNotification: true),
        onOpenSpeedDial: _openEmergencySpeedDial,
        onOpenSafeChat: _openSafeChat,
        onShowToast: _showToast,
      ),
    );
  }

  void _openCareGuide(String guideId) {
    final guide = Neo4jKnowledgeGraphService.careGuidesGraph[guideId] ??
        Neo4jKnowledgeGraphService.careGuidesGraph.values.first;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Neo4jCareGuideReaderSheet(
        guide: guide,
        graphStatus: _graphStatus,
        onOpenSafeChat: _openSafeChat,
        onShowToast: _showToast,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isPinLocked || _isMultiTenantSelectorOpen) {
      return MotherAuthPinScreen(
        tenants: _tenants,
        lockedTenant: _isPinLocked ? _activeTenant : null,
        onAuthenticated: _handleAuthenticatedTenant,
        onRegisterTenant: _handleRegisterNewTenant,
        onSignOutSavedSession: () async {
          await OfflineVaultService.saveActiveSessionTenantId(null);
          if (!mounted) return;
          setState(() {
            _isPinLocked = false;
            _isMultiTenantSelectorOpen = true;
          });
        },
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: NurtureBloomColors.surface.withValues(alpha: 0.92),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2D312E).withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo + Offline Vault Status Pill
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _activeTabIndex = 0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 17,
                              backgroundImage: NetworkImage(_logoUrl),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Niamama',
                              style: NurtureBloomTextStyles.headlineSm.copyWith(
                                color: NurtureBloomColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: NurtureBloomColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: NurtureBloomColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _userCoords.isLiveGps
                                  ? 'GPS Live'
                                  : 'Offline Ready',
                              style: NurtureBloomTextStyles.labelSm.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Actions: SOS Speed-Dial, Calendar Bell, Mother Tenant / PIN Security Avatar
                  Row(
                    children: [
                      InkWell(
                        onTap: _openEmergencySpeedDial,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: NurtureBloomColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.emergency_rounded,
                                size: 16,
                                color: NurtureBloomColors.onTertiaryFixed,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'SOS',
                                style: NurtureBloomTextStyles.labelSm.copyWith(
                                  color: NurtureBloomColors.onTertiaryFixed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _openCalendarReminder(
                          CalendarReminderTarget(
                            id: 'vaccine-6w',
                            title:
                                'Baby ${_activeTenant.babyName} 6-Week Immunizations (Penta 1, PCV 1, OPV 1, Rotavirus 1)',
                            subtitle: 'WHO Primary Protection Series',
                            location:
                                'Midtown Child Welfare Clinic • Room 3B with Dr. Aris',
                            description:
                                '6-week routine immunizations: Penta 1 (5-in-1), PCV 1, OPV 1, and Rotavirus 1.',
                            startDate:
                                DateTime.now().add(const Duration(days: 4)),
                          ),
                        ),
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_none_rounded,
                              color: NurtureBloomColors.onSurfaceVariant,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: NurtureBloomColors.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: _openTenantSecuritySheet,
                        borderRadius: BorderRadius.circular(999),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: NurtureBloomColors.primaryFixed,
                              child: Text(
                                _activeTenant.initials,
                                style: NurtureBloomTextStyles.labelSm.copyWith(
                                  color: NurtureBloomColors.onPrimaryFixed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color:
                                      NurtureBloomColors.surfaceContainerLowest,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _activeTenant.requirePinEveryTime
                                      ? Icons.lock_rounded
                                      : Icons.verified_user_rounded,
                                  size: 11,
                                  color: NurtureBloomColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _activeTabIndex,
        children: [
          HomeDashboardScreen(
            activeTenant: _activeTenant,
            state: _state,
            userCoords: _userCoords,
            gpsStatus: _gpsStatus,
            graphStatus: _graphStatus,
            onToggleProfile: () {
              final next = !_state.isBabyLeoActive;
              _updateState(_state.copyWith(isBabyLeoActive: next));
              _showToast(
                next
                    ? 'Switched focus to Baby ${_activeTenant.babyName} (${_activeTenant.babyAgeWeeks} weeks)'
                    : "Switched focus to ${_activeTenant.mamaFirstName}'s Postnatal Care",
              );
            },
            onOpenTenantSecurity: _openTenantSecuritySheet,
            onSelectMood: (mood, label) {
              _updateState(_state.copyWith(lastMood: mood));
              if (mood == 'midwife') {
                _openSafeChat();
              } else {
                _showToast(
                  'Saved offline: $label. Take a gentle breath, ${_activeTenant.mamaFirstName}.',
                );
              }
            },
            onLogFeed: (entry) {
              _updateState(
                _state.copyWith(feedLogs: [entry, ..._state.feedLogs]),
              );
              _showToast(
                'Saved offline: ${entry.side} side (${entry.durationMinutes}m) for Baby ${_activeTenant.babyName}',
              );
            },
            onRequestLocation: _requestLiveLocation,
            onNavigateTab: (idx) => setState(() => _activeTabIndex = idx),
            onOpenWhoPass: _openWhoDigitalPass,
            onOpenSafeChat: _openSafeChat,
            onOpenSpeedDial: _openEmergencySpeedDial,
            onOpenClinicalTriage: _openClinicalTriage,
            onOpenCareGuide: _openCareGuide,
            onOpenCalendarReminder: _openCalendarReminder,
            onShowToast: _showToast,
          ),
          TimelineVaccinesScreen(
            state: _state,
            onToggleCue: (cueId) {
              final nextCues = Map<String, bool>.from(_state.engagementCues);
              nextCues[cueId] = !(nextCues[cueId] ?? false);
              _updateState(_state.copyWith(engagementCues: nextCues));
            },
            onCaptureSmileMemory: () {
              final nextCount = _state.smileMemoriesCount + 1;
              _updateState(_state.copyWith(smileMemoriesCount: nextCount));
              _showToast(
                'Smile memory #$nextCount saved to Baby ${_activeTenant.babyName}’s offline journal!',
              );
            },
            onCompleteTummyTimeRound: () {
              final nextMins = (_state.tummyTimeMinutesToday + 2)
                  .clamp(0, _state.tummyTimeGoalMinutes);
              _updateState(_state.copyWith(tummyTimeMinutesToday: nextMins));
              _showToast('Wonderful job! 2-minute Tummy Time round saved.');
            },
            onToggleVaccineDose: (doseId, doseName) {
              final nextVaccines =
                  Map<String, bool>.from(_state.completedVaccines);
              final isNowDone = !(nextVaccines[doseId] ?? false);
              nextVaccines[doseId] = isNowDone;
              _updateState(_state.copyWith(completedVaccines: nextVaccines));
              _showToast(
                isNowDone
                    ? 'Marked $doseName completed on WHO Digital Card'
                    : 'Unmarked $doseName',
              );
            },
            onOpenWhoPass: _openWhoDigitalPass,
            onOpenSafeChat: _openSafeChat,
            onNavigateTab: (idx) => setState(() => _activeTabIndex = idx),
            onOpenCalendarReminder: _openCalendarReminder,
            onShowToast: _showToast,
          ),
          CareMapScreen(
            userCoords: _userCoords,
            gpsStatus: _gpsStatus,
            onRequestLocation: _requestLiveLocation,
            onOpenSpeedDial: _openEmergencySpeedDial,
            onShowToast: _showToast,
          ),
          SupportCircleScreen(
            state: _state,
            userCoords: _userCoords,
            onToggleCircle: (circleId) {
              final nextCircles = Map<String, bool>.from(_state.joinedCircles);
              final nextJoined = !(nextCircles[circleId] ?? false);
              nextCircles[circleId] = nextJoined;
              _updateState(_state.copyWith(joinedCircles: nextCircles));
              _showToast(
                nextJoined
                    ? 'Joined circle! Saved to your offline village.'
                    : 'Left community circle',
              );
            },
            onOpenSafeChat: _openSafeChat,
            onOpenSpeedDial: _openEmergencySpeedDial,
            onOpenCareGuide: _openCareGuide,
            onShowToast: _showToast,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: NurtureBloomColors.surface.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D312E).withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 76,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(
                  index: 0,
                  icon: Icons.eco_rounded,
                  label: 'Home',
                ),
                _buildBottomNavItem(
                  index: 1,
                  icon: Icons.event_available_rounded,
                  label: 'Timeline',
                ),
                _buildBottomNavItem(
                  index: 2,
                  icon: Icons.local_hospital_rounded,
                  label: 'Care Map',
                ),
                _buildBottomNavItem(
                  index: 3,
                  icon: Icons.favorite_rounded,
                  label: 'Support',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = _activeTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeTabIndex = index),
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? NurtureBloomColors.primaryFixed
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? NurtureBloomColors.onPrimaryFixed
                  : NurtureBloomColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: NurtureBloomTextStyles.labelSm.copyWith(
                color: isActive
                    ? NurtureBloomColors.onPrimaryFixed
                    : NurtureBloomColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
