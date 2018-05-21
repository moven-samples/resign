#!/usr/bin/env bash

BUNDLE_ID=com.fileformatnet.reader
DISPLAY_NAME=Resigned-msireader
ENTITLEMENTS=MSIReader-signed.entitlements
IDENTITY="iPhone Distribution: Andrew Marcuse (U9T36T8J82)"
IPA=MSIReader-unsigned-20180518-0428.ipa
OUTPUT=MSIReader-signed.ipa
PROVISIONING_PROFILE=../certs/Integration_Sample_Reader_U9T36T8J82.mobileprovision

./resign.sh \
  "$IPA" \
  "$IDENTITY" \
  --provisioning "$PROVISIONING_PROFILE" \
  --bundle-id "$BUNDLE_ID" \
  --display-name "$DISPLAY_NAME" \
  --entitlements "$ENTITLEMENTS" \
  $OUTPUT
