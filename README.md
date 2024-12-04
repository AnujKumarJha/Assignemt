# NewsApp

## Overview
This project contains the `NewsViewModel` class responsible for fetching, managing, and displaying news articles. It includes functionalities such as bookmarking articles and selecting article URLs.

## Classes and Functions

### 1. **`NewsViewModel`**
The `NewsViewModel` manages the state of news articles in the app, handles bookmarking, and stores the selected article URL.

#### Key Methods:
- **`fetchTopHeadlines()`**: Fetches top headlines from the API.
- **`toggleBookmark(article:)`**: Adds or removes an article from bookmarks.
- **`isBookmarked(article:)`**: Checks if an article is bookmarked.
- **`selectArticleURL(url:)`**: Stores the selected article URL.

### 2. **`Article`**
Represents a news article, including its title, description, source, and other details.

#### Key Properties:
- **`source`**: The source of the article.
- **`author`**: The author of the article (optional).
- **`title`**: The title of the article.
- **`description`**: A brief description of the article.
- **`url`**: The article URL.
- **`urlToImage`**: An optional URL to an image associated with the article.
- **`publishedAt`**: The publication date of the article.
- **`content`**: The full content of the article (optional).

### 3. **`Source`**
Represents the source of a news article.

#### Key Properties:
- **`id`**: An optional identifier for the source.
- **`name`**: The name of the news source.

