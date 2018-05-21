#!/bin/bash

PROVISIONING_PROFILE=../certs/Integration_Dev_Reader_U9T36T8J82.mobileprovision


security cms -D -i "$PROVISIONING_PROFILE" > tmp_pp_entitlements.plist
/usr/libexec/PlistBuddy -x -c "Print :Entitlements" tmp_pp_entitlements.plist > "tmp_output_entitlements.plist"
