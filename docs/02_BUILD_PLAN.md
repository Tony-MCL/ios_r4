# R4 iOS – Build Plan

## Development approach

Build iteratively and pragmatically.

The first objective is not a polished App Store build. The first objective is to prove the complete iOS-specific R4 workflow on the dedicated physical iPhone.

Existing Android behavior is the product reference. iOS-native behavior is preferred whenever the platforms differ.

## Fixed working environment

Development is performed from a Windows Zenbook.

The project must not depend on the developer owning or routinely using a Mac. Apple-specific compilation, signing, archiving and upload tasks are performed on a cloud-hosted macOS runner.

Normal development loop:

```text
Windows / Zenbook
      ↓
GitHub
      ↓
GitHub Actions macOS runner
      ↓
Build / sign / archive / upload
      ↓
TestFlight
      ↓
Dedicated iPhone
```

No phase is considered properly implemented if it only works through undocumented manual Xcode configuration on a local Mac.

## Phase 0 – Production foundation

Create the repository-controlled iOS project configuration and both targets without requiring local Xcode.

### Deliverables

- Repository-controlled project manifest/configuration
- Main application target: `R4`
- Keyboard extension target: `R4Keyboard`
- Swift / SwiftUI foundation
- Bundle identifiers
- App Group identifiers and entitlements
- Basic folder structure
- GitHub Actions macOS build workflow
- Generated Xcode project on CI
- Both targets compile on CI
- Signing/TestFlight path documented and prepared

### Phase 0A – unsigned CI proof

Before Apple signing credentials are introduced, CI must be able to generate the project and compile the app + keyboard extension for an iOS simulator target.

This proves that the project structure and source target membership are valid without requiring certificates or provisioning profiles.

### Phase 0B – signed device/TestFlight proof

Configure App Store Connect/signing credentials as GitHub secrets or equivalent protected CI configuration.

The CI pipeline must then:

- Build for a physical iOS device
- Sign the main app and keyboard extension correctly
- Archive the application
- Upload a build to App Store Connect/TestFlight

### Exit criteria

A minimal R4 app and R4 keyboard are built entirely through GitHub-hosted macOS infrastructure and a build reaches the dedicated iPhone through TestFlight without requiring a local Mac.

## Phase 1 – Prove the keyboard workflow

Validate the highest-risk platform behavior before building the product UI.

### Step 1 – Hard-coded insertion

The keyboard displays one hard-coded title:

```text
Bear
```

Tapping it inserts:

```text
Test message from R4
```

into the current text field using the keyboard extension API.

### Step 2 – Shared App Group data

The main app writes a test message into the shared App Group container.

The keyboard reads that same message and displays its title.

Tapping the title inserts the stored message text.

### Step 3 – Permission validation

Confirm on the dedicated physical iPhone:

- Whether Full Access is required for the shared container
- Exact user setup flow
- Behavior after enabling/disabling Full Access
- Keyboard behavior in at least Apple Notes or Messages
- Keyboard behavior in the intended game/chat scenario where practical

### Exit criteria

This complete chain works reliably:

```text
R4 main app
   ↓
saves message
   ↓
other app text field
   ↓
R4 keyboard
   ↓
displays saved title
   ↓
user taps title
   ↓
full text appears at cursor
```

Do not proceed to visual replication until this gate is green.

## Phase 2 – Shared message store

Replace test storage with the MVP data layer.

### Deliverables

- `Message.swift`
- `SharedContainer.swift`
- `MessageStore.swift`
- JSON encoding/decoding
- Atomic writes
- Error handling appropriate for a local utility app
- Create/read/update/delete operations for the main app
- Read operation for the keyboard

### Message model

Minimum fields:

- `id`
- `title`
- `text`
- `createdAt`
- `updatedAt`

### Exit criteria

Messages survive app restart and are consistently visible to both the main app and keyboard extension.

## Phase 3 – Main app MVP

Recreate the stable Android R4 product experience in SwiftUI.

### Deliverables

- Main screen
- Message archive
- Empty state
- Create message
- Edit message
- Delete with confirmation
- Settings
- About / Info
- Legal links
- Keyboard setup guidance

### Design goal

Match Android R4 as closely as practical in:

- Logo
- Color palette
- Spacing and hierarchy
- Message presentation
- Buttons and controls
- Product copy
- General visual character

Do not copy Android UI conventions when a native iOS control provides the same experience more reliably.

### Exit criteria

The user can fully administer the same message library that the keyboard reads.

## Phase 4 – Production keyboard UI

Replace the technical test keyboard with the actual R4 keyboard interface.

### Deliverables

- R4 header
- Scrollable message-title list
- Tap to insert full text
- Globe / Next Keyboard control
- Empty state
- Shared R4 colors/design tokens where suitable
- Sensible handling of long titles
- Reliable refresh of changed message data

### Explicit exclusions

- No full QWERTY keyboard
- No message editor inside the keyboard
- No automatic sending
- No unsupported overlay behavior

### Exit criteria

Using R4 from another app is fast enough to satisfy the original R4 purpose: select prepared text with minimal interruption and insert it directly into the active field.

## Phase 5 – Language and product parity

Port the established Android product content.

### Deliverables

- Same supported language structure as Android where applicable
- Localized strings
- Localized Info.plist strings where needed
- Tagline
- Settings copy
- About copy
- Legal links
- Keyboard permission/setup explanations
- Logo and final app assets

### Exit criteria

The iOS application is recognizably the same Morning Coffee Labs R4 product as Android, rather than a separate redesign.

## Phase 6 – Physical-device validation and MVP hardening

Use R4 in real workflows rather than relying only on simulator tests.

### Test areas

- Create/edit/delete multiple messages
- Restart app and verify persistence
- Enable/disable keyboard
- Switch repeatedly between Apple keyboard and R4
- Insert short and long messages
- Insert multiline messages
- Insert emoji and non-ASCII characters
- Update a message while the keyboard has previously been opened
- Delete a message and verify keyboard refresh
- Test in multiple ordinary text fields
- Verify expected behavior where third-party keyboards are blocked
- Verify secure-field behavior
- Test without internet connectivity

### Product test

Use R4 in actual repeated-message communication over several days where possible.

The key product question remains:

> Is the workflow noticeably faster and less irritating with R4 than without it?

If not, improve the core interaction before adding features.

## MVP definition of done

R4 iOS MVP is functionally complete when the user can:

1. Receive/install the current R4 build on the dedicated iPhone through TestFlight.
2. Launch R4 on iPhone.
3. Understand how to enable the R4 keyboard.
4. Create a message with title and text.
5. Save the message locally.
6. See stored messages in the main app.
7. Edit a message.
8. Delete a message safely.
9. Open a normal text field in another app.
10. Switch to the R4 keyboard.
11. See stored message titles.
12. Tap a title.
13. Have the complete message inserted at the cursor.
14. Switch back to another keyboard when needed.
15. Use the core workflow without internet connectivity.
16. Build and release updates without requiring a local Mac.

## Working rule

Each phase should end in a working state before moving to the next.

Prefer small verifiable changes over large rewrites. Preserve working functionality unless a deliberate architectural change has been agreed first.
