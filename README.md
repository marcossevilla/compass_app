# Compass Architecture Case Study 🧭🏗️

The Compass architecture case study is a project that shows how to structure and architect a Flutter full stack application. It is a rewrite of the Compass application created by the [Firebase GenKit team](https://developers.googleblog.com/en/how-firebase-genkit-helped-add-ai-to-our-compass-app/) that is under the [Flutter official architecture samples](https://docs.flutter.dev/app-architecture/case-study).

The original project is an app that helps users build and book itineraries for trips. The app communicates with an HTTP server that was built using the [shelf](https://pub.dev/packages/shelf) package. Some of the features include development and production environments, brand-specific styling, and high test coverage.

## Goal 🥅

The goal behind this rewrite is to assess how well the architecture of the project is following best practices, and whether it can be improved. The code philosophy applied is [Very Good Engineering](https://engineering.verygood.ventures/engineering/philosophy/), an opinionated approach to Flutter development.

The reason I decided to rewrite the project is because I saw many members from the community think there was a lack of consistency and a clear architecture in the original project, making it hard to understand and maintain. I noticed patterns that should be avoided and I intend to evidence in the codebase and in a future essay I plan to write.

The rewrite should help the community understand architectural choices, argument for and against each design decision, and apply them in future projects. This shouldn't be a one-size-fits-all solution, your project can work better with a different set of choices, but this is an opinionated take as I previously mentioned.

## Setting up ⚙️

By default, the app is configured to use the `development` environment. You can change the environment by running the following command:

```bash
$ flutter run --flavor development --target lib/main_development.dart
$ flutter run --flavor staging --target lib/main_staging.dart
$ flutter run --flavor production --target lib/main_production.dart
```

* To get the HTTP server running and retrieving data, simulating a real app experience. This is a "dummy" server, that has endpoints that simply return fake data. The server can be found in [`package/api`](packages/api/), so you need to run the server locally before running the Flutter application.

```bash
# package/api
$ dart_frog dev
# ✓ Running on http://localhost:8080
# [hotreload] Hot reload is enabled.
# Press either R or r to reload
 
# packages/app
$ flutter run --flavor development --target lib/main_development.dart
```

## Roadmap 🗺️

This project is a work in progress and I plan to continue adding features and making improvements to the architecture. The following features are planned:

- [x] Rewrite the app code to follow [Very Good Architecture](https://verygood.ventures/blog/very-good-flutter-architecture).
- [x] Move data and domain layer to standalone packages.
- [x] Refactor project to use a monorepo structure by implementing [Pub Workspaces](https://dart.dev/tools/pub/workspaces).
- [x] Add GitHub workflows for every package in the monorepo.
- [x] Rewrite the server code to use [`package:dart_frog`](https://pub.dev/packages/dart_frog).
- [ ] Add unit and widget tests to each package.
- [ ] Add integration tests for feature parity with the original app.
- [ ] Reach 100% test coverage in each package.

These points are to reach feature parity with the original app and also my non-negotiable standards. But I also want to use this project to showcase how I think Flutter apps should be built, so I plan to implement the following features:

- [ ] Deep linking.
- [ ] Code push with [`package:shorebird_code_push`](https://pub.dev/packages/shorebird_code_push).
- [ ] Crash reporting with Sentry for both frontend ([`sentry_flutter`](https://pub.dev/packages/sentry_flutter)) and backend ([`sentry_dart_frog`](https://pub.dev/packages/sentry_dart_frog)).