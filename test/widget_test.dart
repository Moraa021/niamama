import 'package:flutter_test/flutter_test.dart';
import 'package:niamama/services/neo4j_knowledge_service.dart';
import 'package:niamama/services/offline_vault_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'Multi-tenant isolation: two mothers have completely independent offline vaults',
    () async {
      final tenants = await OfflineVaultService.loadTenants();
      expect(tenants.length, greaterThanOrEqualTo(2));

      final amara = tenants[0]; // tenant-amara (Baby Leo)
      final wanjiku = tenants[1]; // tenant-wanjiku (Baby Zuri)

      // Load initial states for both mothers
      final amaraInitial = await OfflineVaultService.loadState(tenant: amara);
      final wanjikuInitial =
          await OfflineVaultService.loadState(tenant: wanjiku);

      expect(amaraInitial.smileMemoriesCount, 1);
      expect(wanjikuInitial.smileMemoriesCount, 3);

      // Amara logs a new feed and increments smile memories to 9
      final amaraUpdated = amaraInitial.copyWith(
        smileMemoriesCount: 9,
        lastMood: 'resting',
      );
      await OfflineVaultService.saveState(amaraUpdated, tenantId: amara.id);

      // Reload both vaults and verify Wanjiku's data was untouched
      final amaraReloaded = await OfflineVaultService.loadState(tenant: amara);
      final wanjikuReloaded =
          await OfflineVaultService.loadState(tenant: wanjiku);

      expect(amaraReloaded.smileMemoriesCount, 9);
      expect(amaraReloaded.lastMood, 'resting');
      expect(wanjikuReloaded.smileMemoriesCount, 3);
      expect(wanjikuReloaded.lastMood, isNull);
    },
  );

  test(
    'Session persistence & PIN requirement toggle persist across restarts',
    () async {
      final tenants = await OfflineVaultService.loadTenants();
      final amara = tenants.first;

      // Save Amara as the active logged-in session
      await OfflineVaultService.saveActiveSessionTenantId(amara.id);
      expect(await OfflineVaultService.loadActiveSessionTenantId(), amara.id);

      // Enable "Require PIN on every access" for Amara
      final updatedAmara = amara.copyWith(requirePinEveryTime: true, pinCode: '4321');
      await OfflineVaultService.saveTenants([updatedAmara, tenants[1]]);

      final reloadedTenants = await OfflineVaultService.loadTenants();
      expect(reloadedTenants.first.requirePinEveryTime, isTrue);
      expect(reloadedTenants.first.pinCode, '4321');
    },
  );

  test(
    'Neo4j Grounded Intelligence returns WHO-cited clinical guidance & triage pathways',
    () async {
      expect(Neo4jKnowledgeGraphService.clinicalTriageGraph.length, 6);
      expect(Neo4jKnowledgeGraphService.careGuidesGraph.length, 3);

      final guidance =
          await Neo4jKnowledgeGraphService.queryGroundedMidwifeGuidance(
        topics: ['Feeding / Latch'],
        userText: 'Baby has fever 38.5',
        mamaFirstName: 'Amara',
        babyName: 'Leo',
      );

      expect(guidance.replyText, contains('URGENT ER'));
      expect(guidance.replyText, contains('WHO-IMCI-2024'));
      expect(guidance.cypherCitation, contains(':Symptom'));
    },
  );
}
