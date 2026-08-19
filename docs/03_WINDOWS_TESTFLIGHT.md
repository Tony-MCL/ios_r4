# R4 iOS – Windows to TestFlight

## Project rule

R4 iOS must be buildable and releasable without a developer-owned Mac.

Normal working environment:

```text
Windows / Zenbook
      ↓
GitHub repository
      ↓
GitHub Actions macOS runner
      ↓
App Store Connect / TestFlight
      ↓
iPhone test device
```

A macOS runner is required because Apple's iOS toolchain is macOS-only, but no physical Mac is part of the R4 workflow.

## CI workflows

### `iOS Build`

Runs on pushes and pull requests.

Purpose:

- Generate `R4.xcodeproj` with XcodeGen
- Compile the app and keyboard extension for the iOS Simulator
- Require no signing credentials
- Remain the fast green build gate during development

### `TestFlight`

Runs only when manually started with `workflow_dispatch`.

Purpose:

- Generate the Xcode project
- Reconstruct the App Store Connect API key on the temporary runner
- Import the Apple Distribution certificate into a temporary keychain
- Let Xcode automatically manage provisioning through Apple
- Archive the main app including the keyboard extension
- Upload the archive to App Store Connect / TestFlight

The runner and its temporary keychain disappear after the job.

## Apple identifiers

```text
Main app:
com.morningcoffeelabs.r4

Keyboard extension:
com.morningcoffeelabs.r4.keyboard

Shared App Group:
group.com.morningcoffeelabs.r4
```

Both App IDs must have the shared App Group enabled in the Apple Developer portal.

## GitHub repository secrets

Already configured:

```text
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_PRIVATE_KEY
```

Still required before the first TestFlight run:

```text
APPLE_TEAM_ID
IOS_DISTRIBUTION_CERTIFICATE_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
```

Never commit signing keys, certificates, API keys or provisioning profiles to the repository.

## Provisioning strategy

R4 uses automatic provisioning from the CI runner instead of storing `.mobileprovision` files in GitHub.

The TestFlight workflow calls `xcodebuild` with:

- `-allowProvisioningUpdates`
- App Store Connect API key authentication
- the Apple Developer Team ID
- automatic code-signing style

This allows Xcode to obtain suitable provisioning for both bundle IDs and their enabled capabilities during the release build.

## Distribution certificate

The CI runner still requires an Apple Distribution certificate together with its private key.

Because the private key must remain under the developer's control, the certificate is prepared once and exported as a password-protected `.p12` file. The `.p12` itself is not committed. Its Base64 representation and password are stored as GitHub repository secrets.

The certificate setup can be performed from Windows using OpenSSL and the Apple Developer web portal; Xcode on a local Mac is not required.

## Release safety

The TestFlight workflow is manual by design. Normal pushes must never upload builds to App Store Connect automatically.

Build number uses GitHub's workflow run number so repeated TestFlight uploads receive a new build number automatically.
