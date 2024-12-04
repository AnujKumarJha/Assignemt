
import SwiftUI


// Extracted ArticleRow for reusability
struct ArticleRowView: View {
    let article: Article
    @ObservedObject var viewModel: NewsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(article.title)
                .font(.headline)
                .foregroundColor(.blue)
                .onTapGesture {
                    viewModel.selectArticleURL(article.url)
                }

            if let description = article.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }

            // Bookmark button
            HStack {
                Spacer()
                Button(action: {
                    viewModel.toggleBookmark(article: article)
                }) {
                    Image(systemName: viewModel.isBookmarked(article: article) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.yellow)
                        .padding(5)
                }
            }
        }
        .padding(.vertical, 8) // Add padding between each article row
    }
}
