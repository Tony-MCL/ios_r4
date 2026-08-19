import Foundation

struct SharedTestMessagePayload: Codable {
    let title: String
    let text: String
}

enum SharedTestMessage {
    static let appGroupIdentifier = "group.com.morningcoffeelabs.r4"
    static let fileName = "phase1-test-message.json"

    static func save(title: String, text: String) throws {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            throw SharedTestMessageError.appGroupUnavailable
        }

        let payload = SharedTestMessagePayload(title: title, text: text)
        let data = try JSONEncoder().encode(payload)
        let fileURL = containerURL.appendingPathComponent(fileName)
        try data.write(to: fileURL, options: .atomic)
    }

    static func load() -> SharedTestMessagePayload? {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            return nil
        }

        let fileURL = containerURL.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }

        return try? JSONDecoder().decode(SharedTestMessagePayload.self, from: data)
    }
}

enum SharedTestMessageError: LocalizedError {
    case appGroupUnavailable

    var errorDescription: String? {
        switch self {
        case .appGroupUnavailable:
            return "R4 could not access the shared App Group container."
        }
    }
}
