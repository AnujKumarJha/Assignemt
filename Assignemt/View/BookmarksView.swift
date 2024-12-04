

import SwiftUI

struct BookmarksView: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        VStack {
            // Display Bookmarked Articles
            List(viewModel.bookmarkedArticles) { article in
                ArticleRowView(article: article, viewModel: viewModel)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
    }
}
