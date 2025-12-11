# Quickstart

## Prerequisites
- Flutter SDK (Latest Stable)
- Dart SDK
- An OpenWRT Router (reachable via network)

## Installation

1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd easywrt
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run Code Generation** (for Hive/Riverpod):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## Running the App

### Debug Mode
```bash
flutter run
```

### Profile Mode (Performance Testing)
```bash
flutter run --profile
```

## Development Workflow

1. **Modify Entities**: Update `lib/data/models/`.
2. **Regenerate Adapters**: Run `dart run build_runner build`.
3. **Add New UI**: Create Widget in `lib/presentation/`.
4. **Test**:
   ```bash
   flutter test
   ```
