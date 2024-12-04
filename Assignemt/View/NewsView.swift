import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    let categories = ["business", "sports", "general", "health"]

    var body: some View {
        TabView {
            // Top Headlines Tab
            NavigationView {
                VStack {
                    // Picker for selecting category
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.capitalized).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 50) // Adjust for better spacing below the navigation title

                    // Articles List
                    List(viewModel.articles) { article in
                        VStack(alignment: .leading, spacing: 10) {
                            // AsyncImage to load image from URL
                            if let imageURL = article.urlToImage, let url = URL(string: imageURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView() // Loading indicator
                                            .frame(width: 100, height: 100) // Default frame for loading
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit() // Scales the image to fit within the given frame
                                            .frame(width: 370, height: 200) // Increase the width/height as needed
                                            .clipShape(RoundedRectangle(cornerRadius: 10)) // Optional rounding
                                    case .failure:
                                        Image(systemName: "photo") // Default image on failure
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .padding(.bottom, 10) // Padding for the image
                            }

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
                    .listStyle(PlainListStyle())
                    .padding(.bottom, 10) // Add bottom padding here
                }
                .navigationTitle("Top Headlines") // Set title for this view
                .navigationBarTitleDisplayMode(.large) // Inline title display
                .onAppear {
                    viewModel.fetchTopHeadlines()
                    viewModel.loadBookmarks()
                }
                .onChange(of: viewModel.selectedCategory) { _ in
                    viewModel.fetchTopHeadlines()
                }
                .sheet(item: $viewModel.selectedURL) { identifiableURL in
                    WebView(url: identifiableURL.url) // Use URL from IdentifiableURL
                }
            }
            .tabItem {
                Label("Headlines", systemImage: "newspaper")
            }

            // Bookmarks Tab
            BookmarksView(viewModel: viewModel)
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensure navigation style is consistent
    }
}
