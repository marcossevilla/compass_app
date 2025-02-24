# Contributing to Compass App

Thank you for your interest in contributing to Compass App! We appreciate your help in making this project better.

This document outlines the guidelines for contributing to our monorepo, which includes the `app` and `api` packages.

## Table of Contents

1.  **Getting Started**
    * Setup the Project
    * Project Structure
2.  **Making Changes**
    * Branching
    * Coding Standards
    * Testing
    * Documentation
    * Committing Changes
3.  **Submitting Changes**
    * Pull Requests
    * Code Reviews
4.  **Reporting Issues**
    * Bug Reports
    * Feature Requests
5.  **Community Guidelines**

## 1. Getting Started

### Setup the Project

1.  **Clone the repository:**

    ```bash
    git clone git@github.com:marcossevilla/compass_app.git
    cd compass_app
    ```

2.  **Install Flutter and Dart:**

    Ensure you have the Flutter SDK and Dart SDK installed. You can follow the official Flutter installation guide: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install). Make sure you have the project's current version by checking the app package's [pubspec.yaml](https://github.com/marcossevilla/compass_app/tree/main/packages/app/pubspec.yaml#L8) file.

3.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

### Project Structure

Our monorepo is structured as follows:

```
compass_app/
├── packages/
│   ├── app/          # Flutter application package
│   │   ├── lib/
│   │   │   ├── ...   # Application code
│   │   ├── test/
│   │   │   ├── ...   # Application tests
│   │   └── pubspec.yaml
│   ├── api/          # Dart API package
│   ├── lib/
│   │   ├── ...   # API code
│   ├── test/
│   │   ├── ...   # API tests
│   └── pubspec.yaml
├── .gitignore
├── pubspec.yaml  # Root pubspec (for monorepo setup)
└── README.md
```

* **`app/`:** Contains the Flutter application code, UI, and business logic.
* **`api/`:** Contains the Dart API package, defining data models, network requests, and other backend logic.

## 2. Making Changes

### Branching

1.  **Create a new branch:**

    ```bash
    git checkout -b feature/[your-feature-name] # or bugfix/[your-bug-name]
    ```

    Use descriptive branch names that indicate the purpose of your changes.

### Coding Standards

* **Dart Style Guide:** Follow the official Dart style guide: [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
* **Flutter Style Guide:** Adhere to the Flutter style guide and best practices.
* **Consistent Formatting:** Use `flutter format` to ensure consistent code formatting.
* **Analyze your code:** Use `flutter analyze` to catch any potential issues.

### Testing

* **Write Tests:** Ensure your changes are covered by appropriate unit, widget, and integration tests.
* **Run Tests:** Run all tests before submitting a pull request:

    ```bash
    flutter test
    ```

* **Test Coverage:** Aim for 100% test coverage as the minimum requirement.

### Documentation

* **Document Public APIs:** Add clear and concise documentation for all public APIs in all the packages (except for `app`).
* **Update README:** If your changes introduce new features or modify existing ones, update the `README.md` accordingly.
* **Inline Comments:** Add inline comments to explain complex logic or decisions.

### Committing Changes

* **Atomic Commits:** Make small, logical commits that each represent a single change.
* **Descriptive Commit Messages:** Use clear and concise commit messages that explain the purpose of your changes. Follow the Conventional Commits specification.

    ```
    feat: Add new feature [feature name]
    fix: Fix bug [bug name]
    docs: Update documentation for [feature/bug]
    refactor: Refactor [component/module]
    test: Add tests for [component/module]
    chore: Update dependencies or configuration
    ```

    Example:

    ```
    feat: Implement user authentication flow
    ```

## 3. Submitting Changes

### Pull Requests

1.  **Push your branch to GitHub:**

    ```bash
    git push origin feature/[your-feature-name]
    ```

2.  **Create a pull request:**

    * Go to the GitHub repository and create a new pull request from your branch to the `main` branch.
    * Provide a clear and descriptive title and description for your pull request.
    * Link any relevant issues or discussions.

### Code Reviews

* **Address Feedback:** Be responsive to feedback from reviewers and make necessary changes.
* **Iterate:** Code reviews are a collaborative process. Be open to suggestions and iterate on your changes.

## 4. Reporting Issues

### Bug Reports

* **Search Existing Issues:** Before creating a new issue, search existing issues to avoid duplicates.
* **Provide Detailed Information:** Include steps to reproduce the bug, expected behavior, and actual behavior.
* **Include Relevant Logs or Screenshots:** If applicable, provide logs or screenshots to help diagnose the issue.

### Feature Requests

* **Describe the Feature:** Clearly describe the feature you would like to see implemented.
* **Explain the Use Case:** Explain how the feature would benefit the project and its users.
* **Provide Examples (if possible):** Include examples or mockups to illustrate your idea.

## 5. Community Guidelines 

* **Be Respectful:** Treat all contributors and users with respect and kindness.
* **Be Inclusive:** Welcome contributions from everyone, regardless of their background or experience.
* **Be Open:** Be open to feedback and suggestions.
* **Collaborate:** Work together to improve the project.

Thank you for contributing to Compass app! We look forward to your contributions.
