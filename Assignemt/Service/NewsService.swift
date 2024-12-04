
import Foundation
import Combine

class NewsService {
    private let apiKey = "839a1105e6de4e1db7cdc248c93693dd" // Use your actual API key here
    private let baseUrl = "https://newsapi.org/v2/top-headlines"

    // Function to fetch top headlines based on the category
    func fetchTopHeadlines(category: String) -> AnyPublisher<[Article], Error> {
        // Construct the URL for the API request
        guard let url = URL(string: "\(baseUrl)?country=us&category=\(category)&apiKey=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        // Perform the network request
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .map { $0.articles } // Extract articles from the response
            .eraseToAnyPublisher()
    }
}
