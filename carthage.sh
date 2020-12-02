#!/usr/bin/env bash

# Usage example: ./carthage.sh build --platform iOS
#
# This script fixes the issue with carthage being unable to produce fat
# frameworks. This is needed until the following issue is fixed:
# https://github.com/Carthage/Carthage/issues/3019

# Forward inner failures.
set -euo pipefail

# Create a temporary xcconfig file for building the dependencies.
xcconfig=$(mktemp /tmp/static.xcconfig.XXXXXX)
trap 'rm -f "$xcconfig"' INT TERM HUP EXIT

# For Xcode 12 make sure EXCLUDED_ARCHS is set to arm architectures otherwise
# the build will fail on lipo due to duplicate architectures.
echo 'EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_simulator__NATIVE_ARCH_64_BIT_x86_64__XCODE_1200 = arm64 arm64e armv7 armv7s armv6 armv8' >> $xcconfig
echo 'EXCLUDED_ARCHS = $(inherited) $(EXCLUDED_ARCHS__EFFECTIVE_PLATFORM_SUFFIX_$(EFFECTIVE_PLATFORM_SUFFIX)__NATIVE_ARCH_64_BIT_$(NATIVE_ARCH_64_BIT)__XCODE_$(XCODE_VERSION_MAJOR))' >> $xcconfig

# Run carthage with the temporary xcconfig file and forwarded arguments.
export XCODE_XCCONFIG_FILE="$xcconfig"
carthage "$@"
