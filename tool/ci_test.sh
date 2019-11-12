#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

flutter packages get
flutter analyze
flutter test --coverage --coverage-path coverage/lcov.info

# Upload coverage results to codecov.io
# bash <(curl -s https://codecov.io/bash) -c -F $PACKAGE
