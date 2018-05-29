# Resigning Process for iOS Apps


Generally speaking, the included `resign.sh` script (taken as-is from [FastLane](https://github.com/fastlane/fastlane/blob/master/sigh/lib/assets/resign.sh))
works *if* you have all your ducks in a row.

This doc explains how to get all your ducks in a row! :duck: :duck: :duck: :duck:

## Before you begin

You need to decide on the identifier for the app. This is in reverse-domain name format. In this doc, I am using `com.partnername.theapp`.  Our
current partner app identifiers are:

 * `nz.co.westpac.cashnav`
 * `com.movencorp.vindi`


You also need to pick a value for the shared keychain group.  In this doc, I am using `com.movencorp.b2bpartner.partnerid`, but it can be any agreed-upon value.  Our current partners use:

  * `com.movencorp.b2bpartner.bca`
  * `nz.co.westpac.moven.cst`

## Generating an unsigned `.ipa` file

The app identifier goes in the .env as `MOVEN_APP_ID`.

The keychain group goes in the .env as `B2BPARTNER_IOS_SHAREDSECRETS_KEYCHAINGROUP`.

The team ID (`IOS_DEVELOPMENT_TEAM`) will be still be Moven's team ID (starts with `25`, also lives in `exportPlist-unsigned`).

Note that there are other parameters (unrelated to signing) that also need to be coordinated with the customer.

The `ios-unsigned` target in the Makefile makes a bunch of substitutions before running the key commands.  If they fail, you can run them directly instead of restarting the whole build process.

 * `xcodebuild clean CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO archive -scheme MovenIntRelease -configuration IntRelease -archivePath Moven.xcarchive`
 * `xcodebuild -exportArchive -archivePath Moven.xcarchive -exportOptionsPlist exportPlist-unsigned.plist -exportPath .`

## Getting the Apple developer stuff

You need two complete sets of the following things, one for development (test, dev, prod), one for distribution (prod AppStore release)

 * Certificate: this needs to be downloaded and installed into the Keychain on the machine doing the build.  Once in the Keychain, grant access to it: if you are doing a build locally, you may get a permissions popup.  Otherwise, right-click on the key -> Get Info -> Access Control -> add `codesign`.
 * App Group: `group.com.partername.theapp.sharedData`.  The build process depends on this exact form.
 * 4 App IDs: all start with `com.partnername.theapp`, then _empty_, `.today`, `.watchkitapp` and `.watchkitappextension`.  All need to have the App Groups service enabled, and the specific App Group checked (which requires an edit after creating).
 * 4 Mobile provisioning profiles: one for each of the App IDs.  

Notes:
 * Choose decent names.  I like `TheApp Xxx`, so everything for a single app is grouped together.  If XCode auto-created one, you can rename it.
 * I found it easier to download the provision profiles to a local directory with decent names.  XCode will also download them to a shared location with GUID names.
 * If you change anything with the App ID, you will need to regenerate and redownload the corresponding provisioning profile.
 * You need to know the "Identity" of the certificate.  This is the string in the keychain for the certificate (not the private key).  It has the developer's ID in it, not the team ID.  You can use `security find-identity -v -p codesigning` to list the installed identities.

## Making a new `.entitlements` file

 * `security cms -D -i "$PROVISIONING_PROFILE" > tmp_pp_entitlements.plist`
 * `/usr/libexec/PlistBuddy -x -c "Print :Entitlements" tmp_pp_entitlements.plist > "tmp_output_entitlements.plist"`

The keychange-access-group section will have a wildcard entry.  Expand it to be the exact value selected (including the Team ID prefix or `$(AppIdentifierPrefix)`).

Double-check that all the other parameters are correct.  If not, you will need to regenerate the provision profiles.

## Signing the file

You now have all the pieces necessary to call `resign.sh`.  I use a script file (`go-dev.sh`) to save typing.

Notes:
 * you need to have multiple `--provisioning` parameters, one for each of the provisioning profiles.

## Loading the signed file onto an iPhone

`ios-deploy -v -b Theapp-signed.ipa`

(You can `brew install ios-deploy` if you don't already have it)
