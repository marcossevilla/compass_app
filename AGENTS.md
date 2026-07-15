# AGENTS.md

Compass App — VGV architecture case study rewriting the Flutter/Firebase Compass sample.

## Repo layout

Dart [Pub Workspaces](https://dart.dev/tools/pub/workspaces) monorepo. Root `pubspec.yaml` owns the `workspace:` list. Each package has `resolution: workspace` — never manage deps in isolation.

```
packages/
  app/                      # Flutter app (presentation layer)
  api/                      # Dart Frog HTTP server (backend)
  api_client/               # Raw HTTP client — data layer
  models/                   # Shared models, json_serializable codegen
  activity_repository/
  authentication_repository/
  booking_repository/
  continent_repository/
  destination_repository/
  itinerary_config_repository/
  user_repository/
```

**Dependency flow (VGV layered architecture):**
`api_client` → `*_repository` packages → `app` (BLoC/Cubit) → widgets

## SDK versions

- Flutter: `^3.35.0` (CI pins `3.35.x`)
- Dart: `^3.9.0`

## Developer commands

### Install all dependencies (run from root)

```bash
dart pub get
```

This resolves the entire workspace. Never `cd` into a package and run `pub get` independently.

### Start the backend server (required before running the app)

```bash
# from packages/api
dart_frog dev
# Starts on http://localhost:8080
```

`ApiClient` defaults to `localhost:8080`. The app will silently fail to load data without the server running.

### Run the Flutter app

Three flavors — always pass `--flavor` and `--target` together:

```bash
# from packages/app
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor staging    --target lib/main_staging.dart
flutter run --flavor production --target lib/main_production.dart
```

### Analyze

```bash
# workspace-wide
flutter analyze

# per package (e.g., api — note: routes/ must be included)
flutter analyze lib routes test   # inside packages/api
```

CI for `packages/api` explicitly analyzes `routes test lib` — `routes/` is not auto-included by `dart analyze`.

### Test

```bash
# Flutter packages (app, api_client, *_repository)
flutter test                    # from within the package directory

# Pure Dart packages (models, api)
dart test                       # from within the package directory
```

Each package has its own CI workflow triggered by path changes. Run tests from the package directory, not the root.

### Codegen (packages/models only)

Models use `json_serializable` — `.g.dart` files are committed. Regenerate after changing any model annotated with `@JsonSerializable`:

```bash
# from packages/models
dart run build_runner build --delete-conflicting-outputs
```

### Localization (packages/app only)

ARB source files live in `lib/l10n/arb/`. Generated output goes to `lib/l10n/gen/`. Regenerate after editing ARB files:

```bash
# from packages/app
flutter gen-l10n
```

`l10n.yaml` config: template is `app_en.arb`, nullable getters are disabled (`nullable-getter: false`).

## Linting

Root `analysis_options.yaml` combines three rule sets:

```yaml
include:
  - package:bloc_lint/recommended.yaml
  - package:dart_frog_lint/recommended.yaml
  - package:very_good_analysis/analysis_options.yaml
```

All packages inherit this via `include: ../../analysis_options.yaml`. `packages/app` adds `public_member_api_docs: false`; `packages/api` also disables `file_names` and excludes `build/**`.

## Testing conventions

- **Mocking**: `mocktail` throughout. Repository mocks are centralized in `packages/app/test/helpers/mocks.dart`.
- **Widget test helper**: `WidgetTester.pumpApp(widget)` extension in `packages/app/test/helpers/pump_app.dart` — wraps in `MaterialApp` with localizations, `AppTheme.standard`, and a `MockGoRouterProvider`.
- **Golden tests**: `alchemist` package in `packages/app`. Platform goldens are **disabled in CI** (gated on `GITHUB_ACTIONS` env var in `flutter_test_config.dart`); only the deterministic `ci/` goldens are committed (`.gitignore` ignores all goldens except `goldens/ci/*.*`).
- **Golden generation runs on CI, not locally.** Write the golden test (or change a widget) and commit — the `app_goldens.yaml` workflow runs `flutter test --update-goldens --tags golden` and pushes the regenerated `ci/` PNGs back to the PR branch. After CI pushes goldens, run `git pull` before continuing. CI auto-updates **all** changed goldens, so the `app` check no longer fails on a changed golden — reviewers must inspect the committed PNG diff in the PR to confirm visual changes are intended. (You can still run `flutter test --update-goldens --tags golden` locally to preview, but the committed goldens are produced by CI.)
- **Golden tag timeout**: `dart_test.yaml` declares a 15s timeout for the `golden` tag — required to suppress alchemist warnings.
- `min_coverage` is currently `0` for all packages in CI (tests are in progress).

## Architecture notes

- **State management**: `flutter_bloc` (BLoC and Cubit). `AppBlocObserver` is wired in `bootstrap.dart`.
- **Navigation**: `go_router` v17. Router defined in `packages/app/lib/routing/router.dart`. Auth redirect is driven by a `ValueNotifier<bool> isAuthenticated`.
- **`HomeCubit` is instantiated in the router** (not injected through the widget tree) so it reloads every time the home page is pushed.
- **Theme**: `AppTheme.standard` + `TagChipTheme` (`ThemeExtension`). No hardcoded colors.
- **Repositories are injected at the top of the widget tree** via `RepositoryProvider` / `context.read<T>()` — see `packages/app/lib/app/view/`.

## CI

One workflow per package in `.github/workflows/`. All use the `VeryGoodOpenSource/very_good_workflows` reusable workflow `flutter_package.yml`. Workflows trigger only on PRs that touch the relevant `packages/<name>/**` path. `main.yaml` runs a spell-check across all `*.md` files. `semantic_pull_request.yaml` enforces Conventional Commits on PR titles.

`app_goldens.yaml` is the exception — a standalone workflow (not the reusable one) that regenerates golden files on PRs touching `packages/app/**` and pushes them back to the PR branch. It pushes with a dedicated GitHub App / PAT token (secrets `GOLDEN_BOT_APP_ID` + `GOLDEN_BOT_PRIVATE_KEY`, or a PAT) so the commit re-triggers CI, and is skipped for fork PRs and for the bot's own push (actor guard) to avoid a commit loop. Until `GOLDEN_BOT_APP_ID` is set, the job no-ops (passes green) with a "secret not set" note instead of failing.

## Commit conventions

Conventional Commits. Branch pattern: `feature/<name>` or `bugfix/<name>`. PRs target `main`.
