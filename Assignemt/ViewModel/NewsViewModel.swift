import SwiftUI
import Combine


class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var bookmarkedArticles: [Article] = []
    @Published var selectedCategory: String = "business"
    @Published var selectedURL: IdentifiableURL? // Changed to IdentifiableURL
    private var allBookmarkedArticles: Set<String> = []  // Store UUIDs as Strings
    private var cancellables: Set<AnyCancellable> = []



    private let apiKey = "839a1105e6de4e1db7cdc248c93693dd"
    private let baseURL = "https://newsapi.org/v2/top-headlines"

    func fetchTopHeadlines() {
        guard let url = URL(string: "\(baseURL)?category=\(selectedCategory)&apiKey=\(apiKey)") else { return }

        // Start the network request to fetch the articles
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .map { $0.articles } // Assuming the API returns an 'articles' key
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching articles: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] articles in
                self?.articles = articles
                self?.loadBookmarks() // Reload bookmarked articles
            }
            .store(in: &cancellables)
    }

    func loadBookmarks() {
        // Load the saved bookmarks (could be from UserDefaults, Database, etc.)
        allBookmarkedArticles = Set(UserDefaults.standard.stringArray(forKey: "bookmarkedArticles") ?? [])
        bookmarkedArticles = articles.filter { article in
            allBookmarkedArticles.contains(article.id.uuidString) // Compare UUID as String
        }
    }

    func toggleBookmark(article: Article) {
        if isBookmarked(article: article) {
            removeBookmark(article: article)
        } else {
            addBookmark(article: article)
        }
    }

    func isBookmarked(article: Article) -> Bool {
        return allBookmarkedArticles.contains(article.id.uuidString) // Compare UUID as String
    }

    private func addBookmark(article: Article) {
        allBookmarkedArticles.insert(article.id.uuidString) // Store UUID as String
        UserDefaults.standard.set(Array(allBookmarkedArticles), forKey: "bookmarkedArticles")
        loadBookmarks() // Reload the bookmarks
    }

    private func removeBookmark(article: Article) {
        allBookmarkedArticles.remove(article.id.uuidString) // Remove UUID as String
        UserDefaults.standard.set(Array(allBookmarkedArticles), forKey: "bookmarkedArticles")
        loadBookmarks() // Reload the bookmarks
    }

    func selectArticleURL(_ url: String) {
        if let articleURL = URL(string: url) {
            selectedURL = IdentifiableURL(url: articleURL)  // Use the custom initializer
        }
    }

}
