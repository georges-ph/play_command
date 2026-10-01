# Contributing

Thanks for your interest in improving Play Command!

## Setup

1. Install the [Dart SDK](https://dart.dev/get-dart) (3.3 or newer).
2. Clone the repo and fetch dependencies:

   ```sh
   git clone https://github.com/georges-ph/play_command.git
   cd play_command
   dart pub get
   ```

3. Run the app:

   ```sh
   dart run
   ```

## Before submitting

Make sure these pass locally (CI runs the same checks):

```sh
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
```

## Submitting a change

1. Fork the repo and create a branch from `main`.
2. Make your change, keeping commits focused.
3. Update `CHANGELOG.md` under an `Unreleased` section if the change is user-facing.
4. Open a pull request and fill in the template.

For larger changes (e.g. a new game), open an issue first so we can discuss it.
