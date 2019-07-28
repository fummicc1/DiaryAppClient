import Foundation

struct Diary: Codable {
    let id: String
    let title: String
    let content: String
    let posterName: String
    let demandDeletionCount: Int
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case posterName = "poster_name"
        case demandDeletionCount = "demend_deletion_count"
        case createdAt = "created_at"
    }
}
