import Foundation

enum SharedTestMessage {
    static let appGroupIdentifier = "group.com.morningcoffeelabs.r4"
    static let titleKey = "phase1.testMessage.title"
    static let textKey = "phase1.testMessage.text"

    static func save(title: String, text: String) -> Bool {
        guard let defaults = UserDefaults(suiteName: appGroupIdentifier) else {
            return false
        }

        defaults.set(title, forKey: titleKey)
        defaults.set(text, forKey: textKey)
        return true
    }

    static func load() -> (title: String, text: String)? {
        guard
            let defaults = UserDefaults(suiteName: appGroupIdentifier),
            let title = defaults.string(forKey: titleKey),
            let text = defaults.string(forKey: textKey)
        else {
            return nil
        }

        return (title, text)
    }
}
