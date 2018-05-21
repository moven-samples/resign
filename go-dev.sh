#!/usr/bin/env bash

BUNDLE_ID=com.fileformatnet.reader
DISPLAY_NAME=Resigned-msireader
ENTITLEMENTS=MSIReader-signed.entitlements
IDENTITY="iPhone Developer: fileformat@gmail.com (P5P8K48Z44)"
IPA=MSIReader-unsigned-20180518-0428.ipa
OUTPUT=MSIReader-signed.ipa
PROVISIONING_PROFILE=../certs/Integration_Dev_Reader_U9T36T8J82.mobileprovision

./resign.sh \
  "$IPA" \
  "$IDENTITY" \
  --provisioning "$PROVISIONING_PROFILE" \
  --bundle-id "$BUNDLE_ID" \
  --display-name "$DISPLAY_NAME" \
  --entitlements "$ENTITLEMENTS" \
  --verbose \
  $OUTPUT
