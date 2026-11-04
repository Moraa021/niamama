import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/niamama_models.dart';

class OfflineVaultService {
  static const String _legacyStorageKey = 'niamama_flutter_offline_vault_v1';
  static const String _tenantVaultPrefix = 'niamama_tenant_vault_v2_';
  static const String _tenantsRegistryKey = 'niamama_tenants_registry_v1';
  static const String _activeTenantIdKey = 'niamama_active_session_tenant_id_v1';

  static String _vaultKeyForTenant(String tenantId) =>
      '$_tenantVaultPrefix$tenantId';

  /// Loads all registered mother accounts on this device (multi-tenant registry).
  static Future<List<MotherTenantProfile>> loadTenants() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_tenantsRegistryKey);
      if (raw == null || raw.isEmpty) {
        await saveTenants(MotherTenantProfile.defaultTenants);
        return List<MotherTenantProfile>.from(
          MotherTenantProfile.defaultTenants,
        );
      }
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      final tenants = decoded
          .map((e) => MotherTenantProfile.fromJson(e as Map<String, dynamic>))
          .toList();
      if (tenants.isEmpty) {
        return List<MotherTenantProfile>.from(
          MotherTenantProfile.defaultTenants,
        );
      }
      return tenants;
    } catch (_) {
      return List<MotherTenantProfile>.from(MotherTenantProfile.defaultTenants);
    }
  }

  /// Saves the list of registered mother accounts on this device.
  static Future<void> saveTenants(List<MotherTenantProfile> tenants) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(tenants.map((t) => t.toJson()).toList());
      await prefs.setString(_tenantsRegistryKey, encoded);
    } catch (_) {
      // Ignore storage quota errors
    }
  }

  /// Loads the saved session's active mother tenant ID (null if logged out).
  static Future<String?> loadActiveSessionTenantId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString(_activeTenantIdKey);
      if (id == null || id.isEmpty) return null;
      return id;
    } catch (_) {
      return null;
    }
  }

  /// Persists the logged-in mother's session so she doesn't have to log in every time.
  static Future<void> saveActiveSessionTenantId(String? tenantId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (tenantId == null || tenantId.isEmpty) {
        await prefs.remove(_activeTenantIdKey);
      } else {
        await prefs.setString(_activeTenantIdKey, tenantId);
      }
    } catch (_) {
      // Ignore storage errors
    }
  }

  /// Loads the isolated offline vault state for a specific mother tenant.
  static Future<NiamamaState> loadState({MotherTenantProfile? tenant}) async {
    final activeTenant = tenant ?? MotherTenantProfile.defaultTenants.first;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? raw = prefs.getString(_vaultKeyForTenant(activeTenant.id));

      // Seamless migration of legacy single-tenant data to primary tenant if present
      if ((raw == null || raw.isEmpty) &&
          activeTenant.id == MotherTenantProfile.defaultTenants.first.id) {
        raw = prefs.getString(_legacyStorageKey);
      }

      final initial = NiamamaState.initial(tenant: activeTenant);
      if (raw == null || raw.isEmpty) {
        return initial;
      }

      final Map<String, dynamic> data =
          jsonDecode(raw) as Map<String, dynamic>;

      final feedLogsRaw = data['feedLogs'] as List<dynamic>?;
      final contactsRaw = data['contacts'] as List<dynamic>?;
      final chatRaw = data['chatMessages'] as List<dynamic>?;

      return NiamamaState(
        isBabyLeoActive: data['isBabyLeoActive'] as bool? ?? true,
        lastMood: data['lastMood'] as String?,
        feedLogs: feedLogsRaw != null && feedLogsRaw.isNotEmpty
            ? feedLogsRaw
                .map((e) => FeedLogEntry.fromJson(e as Map<String, dynamic>))
                .toList()
            : initial.feedLogs,
        tummyTimeMinutesToday:
            (data['tummyTimeMinutesToday'] as num?)?.toInt() ??
                initial.tummyTimeMinutesToday,
        tummyTimeGoalMinutes:
            (data['tummyTimeGoalMinutes'] as num?)?.toInt() ??
                initial.tummyTimeGoalMinutes,
        smileMemoriesCount:
            (data['smileMemoriesCount'] as num?)?.toInt() ??
                initial.smileMemoriesCount,
        engagementCues: _decodeBoolMap(
          data['engagementCues'],
          initial.engagementCues,
        ),
        completedVaccines: _decodeBoolMap(
          data['completedVaccines'],
          initial.completedVaccines,
        ),
        savedCalendarReminders: _decodeStringMap(
          data['savedCalendarReminders'],
        ),
        contacts: contactsRaw != null && contactsRaw.isNotEmpty
            ? contactsRaw
                .map(
                  (e) => EmergencyContact.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : initial.contacts,
        joinedCircles: _decodeBoolMap(
          data['joinedCircles'],
          initial.joinedCircles,
        ),
        chatMessages: chatRaw != null && chatRaw.isNotEmpty
            ? chatRaw
                .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
                .toList()
            : initial.chatMessages,
        cachedCoordinates: data['cachedCoordinates'] != null
            ? UserCoordinates.fromJson(
                data['cachedCoordinates'] as Map<String, dynamic>,
              )
            : null,
      );
    } catch (_) {
      return NiamamaState.initial(tenant: activeTenant);
    }
  }

  /// Saves the isolated offline vault state for a specific mother tenant.
  static Future<void> saveState(
    NiamamaState state, {
    String? tenantId,
  }) async {
    final targetTenantId =
        tenantId ?? MotherTenantProfile.defaultTenants.first.id;
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = {
        'isBabyLeoActive': state.isBabyLeoActive,
        'lastMood': state.lastMood,
        'feedLogs': state.feedLogs.map((e) => e.toJson()).toList(),
        'tummyTimeMinutesToday': state.tummyTimeMinutesToday,
        'tummyTimeGoalMinutes': state.tummyTimeGoalMinutes,
        'smileMemoriesCount': state.smileMemoriesCount,
        'engagementCues': state.engagementCues,
        'completedVaccines': state.completedVaccines,
        'savedCalendarReminders': state.savedCalendarReminders,
        'contacts': state.contacts.map((e) => e.toJson()).toList(),
        'joinedCircles': state.joinedCircles,
        'chatMessages': state.chatMessages.map((e) => e.toJson()).toList(),
        'cachedCoordinates': state.cachedCoordinates?.toJson(),
      };
      await prefs.setString(
        _vaultKeyForTenant(targetTenantId),
        jsonEncode(payload),
      );
    } catch (_) {
      // Ignore storage quota errors
    }
  }

  static Map<String, bool> _decodeBoolMap(
    dynamic raw,
    Map<String, bool> fallback,
  ) {
    if (raw is Map) {
      final result = Map<String, bool>.from(fallback);
      raw.forEach((key, value) {
        if (key is String && value is bool) {
          result[key] = value;
        }
      });
      return result;
    }
    return Map<String, bool>.from(fallback);
  }

  static Map<String, String> _decodeStringMap(dynamic raw) {
    if (raw is Map) {
      final result = <String, String>{};
      raw.forEach((key, value) {
        if (key is String && value is String) {
          result[key] = value;
        }
      });
      return result;
    }
    return {};
  }

  static String formatRelativeTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    final hours = diff.inHours;
    final remMins = diff.inMinutes % 60;
    return remMins > 0 ? '${hours}h ${remMins}m ago' : '${hours}h ago';
  }
}
