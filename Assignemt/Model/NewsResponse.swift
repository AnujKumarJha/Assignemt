import Foundation

// Root response structure
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// Article structure
struct Article: Identifiable, Codable {
    let id = UUID() // Unique identifier for SwiftUI List
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// Source structure
struct Source: Codable {
    let id: String?
    let name: String
}


