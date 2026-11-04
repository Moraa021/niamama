# Niamama — Open-Source Postpartum & Infant Care Companion

[![License](https://img.shields.io/badge/License-Apache_2.0-3E644A.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg)](https://flutter.dev)
[![Neo4j](https://img.shields.io/badge/Neo4j-5_Community_Graph-008CC1.svg)](https://neo4j.com)

**Niamama** is an open-source, offline-first maternal and child care navigation mobile application built with **Flutter** and powered by **Neo4j Grounded Clinical Intelligence**. It connects mothers to continuum-of-care protocols, WHO immunization schedules, native calendar reminders, emergency speed-dial & GPS SOS routing, and zero-enumeration multi-tenant privacy.

---

## Core Architecture & Features

- **Nurture & Bloom Design System** ([`lib/theme/nurture_bloom_theme.dart`](lib/theme/nurture_bloom_theme.dart)): Warm, non-clinical aesthetic (`#F7FAF5` surface, `#3E644A` sage primary, `#6B5B50` blush sand secondary, `#964327` terracotta tertiary) with `Plus Jakarta Sans` typography.
- **Zero-Enumeration Multi-Tenant Vault & PIN Security** ([`lib/services/offline_vault_service.dart`](lib/services/offline_vault_service.dart), [`lib/screens/mother_auth_pin_screen.dart`](lib/screens/mother_auth_pin_screen.dart), [`lib/widgets/tenant_security_sheet.dart`](lib/widgets/tenant_security_sheet.dart)):
  - Every mother has an isolated offline vault (`niamama_tenant_vault_v2_<tenantId>`).
  - **Saved Session (Auto-Login)** by default so mothers do not need to re-enter credentials every time.
  - **Optional PIN on Every Access**: Mothers can toggle **"Require PIN on Every Access"** so the app locks with their 4-digit PIN whenever opened or resumed from the background.
  - **Strict Privacy**: Users never see a list of other registered mothers or the total number of accounts on the device.
- **Neo4j Grounded Clinical Intelligence** ([`lib/services/neo4j_knowledge_service.dart`](lib/services/neo4j_knowledge_service.dart), [`lib/widgets/clinical_triage_and_guide_sheet.dart`](lib/widgets/clinical_triage_and_guide_sheet.dart), [`docker-compose.yml`](docker-compose.yml)):
  - Connects to Neo4j (`http://localhost:7474/db/neo4j/tx/commit`) and auto-seeds WHO & Ministry of Health clinical triage pathways (`(:Symptom)-[:INDICATES_RISK]->(:TriagePathway)-[:GROUNDED_IN]->(:WHOSource)`).
  - Powers the **"When to See a Doctor"** interactive red-flag triage sheet, **Midwife Safe Chat** grounded replies, and **Midwife-Crafted Wisdom** clinical guides, with automatic fallback to an embedded offline graph mirror when disconnected.
- **Live GPS Geolocation & Routing** ([`lib/services/location_service.dart`](lib/services/location_service.dart)): Native OS location permission prompts, Haversine distance calculation (`km`), and turn-by-turn routing.
- **Native Calendar Reminders** ([`lib/services/calendar_service.dart`](lib/services/calendar_service.dart)): Adds WHO immunization and maternal postnatal checkups to Android Calendar, iOS EventKit, or Google Calendar.
- **Emergency Speed-Dial & Live GPS SOS** ([`lib/widgets/emergency_speed_dial_sheet.dart`](lib/widgets/emergency_speed_dial_sheet.dart)): One-tap calling (`1190` Maternal Helpline, `0800 720 000` Hospital ER Triage, `999 / 112` Ambulance SOS, and personal contacts) plus one-tap SMS with live GPS coordinates.

---

## Quick Start

### 1. Start Neo4j Knowledge Graph (Optional for Live Graph Mode)
```bash
docker compose up -d
```
Neo4j Browser is available at `http://localhost:7474` (credentials: `neo4j` / `niamama_graph_2026`). If Neo4j is not running or the device is offline, Niamama automatically uses its embedded offline clinical graph mirror.

### 2. Run the Flutter App
```bash
flutter pub get
flutter run -d chrome
```
*(Or run `flutter run` with a connected Android/iOS device or emulator.)*

---

## Contributing & CI/CD

We welcome contributions from developers, midwives, and maternal health advocates!
- Read [`CONTRIBUTING.md`](CONTRIBUTING.md) for local setup instructions, architectural rules, and how to run `flutter analyze` and `flutter test`.
- See [`CONTRIBUTORS.md`](CONTRIBUTORS.md) for project maintainers and contributors.
- Automated CI/CD is configured in [`.github/workflows/ci.yml`](.github/workflows/ci.yml) (with a live Neo4j 5 service container, static analysis, unit tests, and web release builds).

---

## Open-Source License

Copyright © 2026 Niamama Open Source Maternal & Infant Care Contributors.  
Licensed under the **Apache License, Version 2.0**. See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE) for full details.
