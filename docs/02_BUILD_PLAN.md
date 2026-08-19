# R4 iOS – Build Plan

## Development approach

Build iteratively and pragmatically.

The first objective is not a polished App Store build. The first objective is to prove the complete iOS-specific R4 workflow on a physical iPhone.

Existing Android behavior is the product reference. iOS-native behavior is preferred whenever the platforms differ.

## Phase 0 – Production foundation

Create the initial Xcode project and targets.

### Deliverables

- Xcode project: `R4`
- Main application target: `R4`
- Keyboard extension target: `R4Keyboard`
- Swift / SwiftUI foundation
- Bundle identifiers
- Signing configuration
- App Group capability for both targets
- Entitlements files
- Basic folder structure
- Both targets compile
- Main app installs and launches on a physical iPhone
- Keyboard extension can be enabled on the physical iPhone

### Exit criteria

A blank/minimal R4 app and a blank/minimal R4 keyboard both run on a real device without signing or extension errors.

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

Confirm on the physical device:

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

1. Install and launch R4 on iPhone.
2. Understand how to enable the R4 keyboard.
3. Create a message with title and text.
4. Save the message locally.
5. See stored messages in the main app.
6. Edit a message.
7. Delete a message safely.
8. Open a normal text field in another app.
9. Switch to the R4 keyboard.
10. See stored message titles.
11. Tap a title.
12. Have the complete message inserted at the cursor.
13. Switch back to another keyboard when needed.
14. Use the core workflow without internet connectivity.

## Working rule

Each phase should end in a working state before moving to the next.

Prefer small verifiable changes over large rewrites. Preserve working functionality unless a deliberate architectural change has been agreed first.
