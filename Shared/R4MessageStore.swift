import Foundation

enum R4MessageStore {
    static let appGroupIdentifier = "group.com.morningcoffeelabs.r4"
    private static let fileName = "messages.json"

    static func loadMessages() -> [R4Message] {
        guard let url = messagesURL(), FileManager.default.fileExists(atPath: url.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([R4Message].self, from: data)
                .sorted { $0.createdAt < $1.createdAt }
        } catch {
            return []
        }
    }

    static func saveMessages(_ messages: [R4Message]) throws {
        guard let url = messagesURL() else {
            throw StoreError.appGroupUnavailable
        }

        let data = try JSONEncoder().encode(messages)
        try data.write(to: url, options: .atomic)
    }

    private static func messagesURL() -> URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)?
            .appendingPathComponent(fileName)
    }

    enum StoreError: LocalizedError {
        case appGroupUnavailable

        var errorDescription: String? {
            switch self {
            case .appGroupUnavailable:
                return "R4 could not open the shared App Group container."
            }
        }
    }
}
