#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

# For some reason, `flutter packages get` tries to run in the example/
# directory, not the root, but `pub get works fine`.
pub get
flutter analyze
flutter test --coverage --coverage-path coverage/lcov.info

# Upload coverage results to codecov.io
# bash <(curl -s https://codecov.io/bash) -c -F $PACKAGE
