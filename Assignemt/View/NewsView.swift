import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    let categories = ["business", "sports", "general", "health"]

    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    // Picker for selecting category
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.capitalized).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top,50) // Adjust for better spacing below the navigation title

                    // Articles List
                    List(viewModel.articles) { article in
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

                            // Article image
                            if let urlToImage = article.urlToImage, let imageURL = URL(string: urlToImage) {
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                } placeholder: {
                                    ProgressView()
                                }
                            }

                            Text(article.publishedAt)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(PlainListStyle())
                }
                .navigationTitle("Top Headlines") // Navigation title is properly set here
                .navigationBarTitleDisplayMode(.large) // Ensures the title is prominent
                .tabItem {
                    Label("Headlines", systemImage: "newspaper")
                }
                .onAppear {
                    viewModel.fetchTopHeadlines()
                    viewModel.loadBookmarks()
                }
                .onChange(of: viewModel.selectedCategory) { _ in
                    viewModel.fetchTopHeadlines()
                }
                .sheet(item: $viewModel.selectedURL) { identifiableURL in
                    WebView(url: identifiableURL.url)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
