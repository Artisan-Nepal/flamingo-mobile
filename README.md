# flamingo_mobile

Flamingo

## Choosing the backend (local / AWS / device)

The API base URL is **not** hardcoded in source. It's read at build time from
`API_BASE_URL` (see `lib/data/remote/api_urls.dart`) and selected per environment
with `--dart-define-from-file`. Never edit source to switch backends.

| Setup                          | Command                                                        |
| ------------------------------ | ------------------------------------------------------------- |
| iOS simulator + local Docker   | `flutter run --dart-define-from-file=config/local-sim.json`   |
| Physical iPhone + local Docker | `flutter run --dart-define-from-file=config/local-device.json`|
| AWS dev                        | `flutter run --dart-define-from-file=config/aws.json`         |

- For a **physical device**, first copy `config/local-device.example.json` to
  `config/local-device.json` and set your Mac's LAN IP (`ipconfig getifaddr en0`).
  That file is gitignored so a machine-specific IP never lands in the repo.
- A bare `flutter run` (or any release build) uses the default in `api_urls.dart`,
  which points at AWS — so localhost can never ship to production.
- dart-defines are compile-time: switching config needs a fresh `flutter run`,
  not a hot reload.
- After an AWS redeploy, update the URL in `config/aws.json` (and the default in
  `api_urls.dart` if you rely on bare runs).

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
