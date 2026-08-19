# R4 iOS – Architecture

## Status

Planned / ready for development.

## Goal

R4 for iOS shall feel like the same product as the existing Android version while using the best native iOS mechanism for the core workflow.

The Android version uses a floating overlay. iOS does not support an equivalent general-purpose overlay, so the iOS version will use a Custom Keyboard Extension.

The product principles remain unchanged:

- Fast
- Simple
- Local
- No account
- No backend
- No required internet connection
- No AI
- Minimal number of taps
- User-controlled, not automated

## Technology

- Swift
- SwiftUI for the main app
- UIKit-hosted Custom Keyboard Extension with SwiftUI content where practical
- App Groups for shared local storage
- JSON-based message storage for the MVP

## Repository and Xcode structure

R4 iOS is a separate repository from Android, but the main app and keyboard extension live in the same Xcode project.

```text
r4-ios/
├── R4.xcodeproj
├── R4/
│   ├── App/
│   │   └── R4App.swift
│   ├── Features/
│   │   ├── Messages/
│   │   │   ├── MessageListView.swift
│   │   │   ├── MessageEditorView.swift
│   │   │   └── MessageRowView.swift
│   │   ├── Settings/
│   │   │   ├── SettingsView.swift
│   │   │   └── AboutView.swift
│   │   └── Onboarding/
│   │       └── KeyboardSetupView.swift
│   ├── Design/
│   │   ├── R4Colors.swift
│   │   ├── R4Typography.swift
│   │   └── R4Components.swift
│   ├── Resources/
│   │   ├── Assets.xcassets
│   │   ├── Localizable.xcstrings
│   │   └── InfoPlist.xcstrings
│   └── Supporting/
│       └── R4.entitlements
├── R4Keyboard/
│   ├── KeyboardViewController.swift
│   ├── KeyboardRootView.swift
│   ├── KeyboardMessageRow.swift
│   ├── Info.plist
│   └── R4Keyboard.entitlements
├── Shared/
│   ├── Models/
│   │   └── Message.swift
│   ├── Storage/
│   │   ├── MessageStore.swift
│   │   └── SharedContainer.swift
│   ├── Design/
│   │   └── SharedDesignTokens.swift
│   └── Configuration/
│       └── R4Constants.swift
└── docs/
```

The files in `Shared/` are compiled into both targets. A separate Swift package is intentionally avoided for the MVP because it would add structure without solving a current problem.

## Targets

### R4

The normal iOS application owns message administration and product information.

Responsibilities:

- Show message archive
- Create messages
- Edit messages
- Delete messages with confirmation
- Settings
- Info / About
- Legal links
- Tagline and product identity
- Language resources
- Explain how to enable and use the R4 keyboard

### R4Keyboard

The Custom Keyboard Extension provides fast access to stored messages from other apps.

Responsibilities:

- Read shared messages
- Show message titles
- Insert the complete selected message at the cursor
- Provide a Next Keyboard / globe control
- Show a simple empty state if no messages exist

The keyboard shall not contain a message editor. Message administration belongs in the main app.

## Core iOS workflow

```text
Create or edit message in R4 app
        ↓
Open a text field in another app
        ↓
Switch to R4 keyboard
        ↓
Select stored message title
        ↓
R4 inserts full message at cursor
        ↓
User sends normally
```

The keyboard inserts the selected message through `textDocumentProxy.insertText(...)`.

This preserves the original R4 concept while making the core interaction native to iOS.

## Shared message data

Both targets share the same local data through an App Group.

Planned identifier:

```text
group.com.morningcoffeelabs.r4
```

The MVP stores messages in a single JSON file inside the shared App Group container:

```text
messages.json
```

Minimum model:

```swift
struct Message: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var text: String
    let createdAt: Date
    var updatedAt: Date
}
```

`MessageStore` owns all loading and writing so views do not handle file storage directly.

The main app performs full CRUD. The keyboard only needs read access for the MVP.

Writes should be atomic so the keyboard never observes a partially written JSON file.

## Why JSON for MVP

R4 has a deliberately small data model:

- A list of messages
- No relationships
- No backend
- No account
- No large datasets

SwiftData or Core Data are therefore not required at this stage. JSON keeps the storage easy to understand, debug, migrate and share with the keyboard extension.

A database can be introduced later only if actual product requirements justify it.

## Keyboard Full Access

Access to the shared App Group container from a third-party keyboard may require the keyboard extension to request Full Access.

R4 remains local even if this permission is required. The product must explain clearly that Full Access is used only so the keyboard can access messages stored by the R4 app and that R4 does not transmit typed text or stored messages to a server.

This requirement must be validated on a physical iPhone during the first technical phase before substantial UI work begins.

## Keyboard design principle

R4 is not intended to replace Apple's normal typing keyboard.

The MVP keyboard should remain focused on stored-message insertion:

```text
┌──────────────────────────┐
│ R4                    🌐 │
├──────────────────────────┤
│ Bear                     │
│ KvK                      │
│ Alliance Rules           │
│ Event Reminder           │
│ Recruitment              │
└──────────────────────────┘
```

The user switches to R4 when a prepared message is needed, inserts the text, and can switch back to another keyboard using the globe control.

No QWERTY implementation is planned for MVP.

## Design parity with Android

The Android R4 version is the visual reference.

The iOS version should reproduce as closely as practical:

- Logo
- Colors
- Typography character
- Main screen hierarchy
- Message archive
- Create/edit/delete flows
- Settings and info
- Tagline
- Legal links
- Language structure
- Overall product feel

The implementation remains native SwiftUI. Jetpack Compose structures should not be copied mechanically.

Shared design values should be centralized, for example:

```text
R4Colors
R4Typography
R4Components
SharedDesignTokens
```

This keeps the main app and keyboard visually consistent without introducing a large design-system abstraction.

## Platform limitations to accept

R4 must not attempt unsupported overlay-style workarounds on iOS.

Known Custom Keyboard limitations include:

- Third-party keyboards are not available in secure text fields such as password fields.
- Individual apps can choose to disallow third-party keyboards.
- iOS controls when and where a keyboard extension is available.

These are platform constraints, not defects to work around.

## MVP exclusions

Do not add the following without a deliberate scope decision:

- Account
- Firebase
- Cloud backup
- Device sync
- AI
- Automatic translation
- Automatic sending
- Game-specific integration
- Message analytics
- Full typing keyboard
- Overlay emulation
- SwiftData/Core Data without a demonstrated need

## Architecture rule

Prefer the smallest native solution that reliably preserves the R4 workflow.

New abstractions, services or persistence layers should only be added when an actual requirement makes them useful.
