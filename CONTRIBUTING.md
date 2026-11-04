# Contributing to Niamama

Thank you for contributing to **Niamama**, the open-source, offline-first maternal and infant care companion! Every improvement helps mothers, newborns, and community midwives navigate postpartum recovery and infant immunization safely.

---

## 1. Local Development Setup

### Prerequisites
- **Flutter SDK** (`>=3.2.0`, `stable` channel)
- **Docker & Docker Compose** (optional for live Neo4j Knowledge Graph mode; the app automatically falls back to its embedded offline graph mirror if Docker is not running)

### Step-by-Step Setup
1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd niamama
   ```
2. **Start the Neo4j 5 Community Knowledge Graph**:
   ```bash
   docker compose up -d
   ```
   - Neo4j HTTP Query API: `http://localhost:7474`
   - Bolt Protocol: `bolt://localhost:7687`
   - Default local credentials: `neo4j` / `niamama_graph_2026`
3. **Install Flutter packages & run**:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```

---

## 2. Architectural & Clinical Standards

When submitting pull requests, please adhere to these core pillars:

1. **Offline-First Resilience**:
   - Every feature must work with zero internet connectivity.
   - Any new clinical query in [`lib/services/neo4j_knowledge_service.dart`](lib/services/neo4j_knowledge_service.dart) must include both a Cypher statement for live Neo4j and a corresponding entry in the embedded offline graph mirror.
2. **Zero-Enumeration Multi-Tenant Privacy**:
   - State changes must be scoped to the active `tenantId` in [`lib/services/offline_vault_service.dart`](lib/services/offline_vault_service.dart).
   - Never expose other registered mothers' names, phone numbers, PINs, or total user counts in any UI screen or error message.
3. **Clinical Grounding (WHO & MOH Protocols)**:
   - Any triage pathway or care guide added to the Neo4j graph must cite an official WHO or Ministry of Health source node (`(:WHOSource)`), such as `WHO-PNC-2024`, `WHO-IMCI-2024`, or `WHO-EPI-2024`.
4. **Nurture & Bloom Design System**:
   - Follow [`docs/architecture/DESIGN.md`](docs/architecture/DESIGN.md) and use tokens from [`lib/theme/nurture_bloom_theme.dart`](lib/theme/nurture_bloom_theme.dart).

---

## 3. Running Lints & Automated Tests Locally

Before opening a Pull Request, verify that static analysis and unit/widget tests pass with zero warnings:

```bash
# 1. Check formatting
dart format --output=none --set-exit-if-changed lib/ test/

# 2. Run static analyzer (must report 0 issues)
flutter analyze

# 3. Run the automated test suite
flutter test
```

---

## 4. CI/CD Pipeline Overview

Our GitHub Actions workflow ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) automatically runs on every push and pull request to `main`:
1. **Neo4j Service Container**: Spins up `neo4j:5-community` with health checks on port `7474`.
2. **Static Analysis & Lint Gate**: Runs `flutter pub get` and `flutter analyze`.
3. **Automated Test Suite**: Executes `flutter test` covering:
   - Multi-tenant offline vault isolation
   - Session persistence & PIN-on-every-access lifecycle enforcement
   - Neo4j Grounded Clinical Intelligence & WHO citation verification
4. **Build Verification**: Builds the Flutter Web bundle (`flutter build web`) and Android debug APK (`flutter build apk --debug`) to ensure all platform targets compile cleanly.

---

## 5. Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat(<scope>): ...` — New feature (e.g., `feat(neo4j): add umbilical cord care triage node`)
- `fix(<scope>): ...` — Bug fix
- `docs(<scope>): ...` — Documentation updates
- `test(<scope>): ...` — Adding or updating tests
- `chore(<scope>): ...` — Build, CI, or dependency updates

By contributing to Niamama, you agree that your contributions will be licensed under the [Apache License, Version 2.0](LICENSE).
