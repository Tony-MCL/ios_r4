import Foundation

struct R4Message: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var text: String
    let createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), title: String, text: String, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.text = text
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
