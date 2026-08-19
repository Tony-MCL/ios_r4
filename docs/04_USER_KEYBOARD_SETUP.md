# R4 iOS – Keyboard setup for users

R4 on iOS uses a Custom Keyboard Extension instead of Android's floating overlay.

The keyboard must be enabled manually by the user after R4 is installed.

## First-time setup

On iPhone:

1. Open **Settings**.
2. Go to **General**.
3. Open **Keyboard**.
4. Open **Keyboards**.
5. Tap **Add New Keyboard...**.
6. Select **R4 Keyboard**.
7. Open **R4 Keyboard** from the keyboard list.
8. Enable **Allow Full Access** when required for R4's shared message data.

After this, R4 Keyboard can be selected from a text field using iOS' normal keyboard-switching control.

## Product requirement

The R4 main app should include clear first-run/setup instructions for this process. The user should not be expected to discover the iOS keyboard settings flow unaided.

The setup text should explain why R4 Keyboard needs to be added and why Full Access is requested in plain language, without implying that R4 reads or transmits unrelated keyboard input.

## Test observation – 2026-08-19

Verified on the dedicated iPhone test device via TestFlight:

**Settings → General → Keyboard → Keyboards → Add New Keyboard... → R4 Keyboard**

After adding R4 Keyboard, iOS exposes the option to grant **Allow Full Access**.
