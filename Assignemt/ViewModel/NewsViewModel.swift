import SwiftUI
import Combine

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var selectedCategory: String = "general" // Default category
    @Published var selectedURL: IdentifiableURL? // Used to pass URL to the WebView
    @Published var bookmarkedArticles: [Article] = []

    private var cancellables = Set<AnyCancellable>()
    private let newsService = NewsService() // Instance of NewsService

    func fetchTopHeadlines() {
        newsService.fetchTopHeadlines(category: selectedCategory) // Fetch articles based on category
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching articles: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] fetchedArticles in
                self?.articles = fetchedArticles
            }
            .store(in: &cancellables)
    }
    // Bookmark an article
        func toggleBookmark(article: Article) {
            if let index = bookmarkedArticles.firstIndex(where: { $0.id == article.id }) {
                bookmarkedArticles.remove(at: index) // Remove if already bookmarked
            } else {
                bookmarkedArticles.append(article)  // Add to bookmarks
            }
            saveBookmarks()
        }

    // Check if an article is bookmarked
        func isBookmarked(article: Article) -> Bool {
            return bookmarkedArticles.contains(where: { $0.id == article.id })
        }

        // Persist bookmarks in UserDefaults
        private func saveBookmarks() {
            if let encoded = try? JSONEncoder().encode(bookmarkedArticles) {
                UserDefaults.standard.set(encoded, forKey: "bookmarkedArticles")
            }
        }
    // Load bookmarks from UserDefaults
        func loadBookmarks() {
            if let data = UserDefaults.standard.data(forKey: "bookmarkedArticles"),
               let decoded = try? JSONDecoder().decode([Article].self, from: data) {
                bookmarkedArticles = decoded
            }
        }
    // Handle article selection and passing URL
    func selectArticleURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            selectedURL = IdentifiableURL(url: url)
        }
    }
}
