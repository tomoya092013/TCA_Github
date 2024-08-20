import Dependencies

extension QiitaClient: DependencyKey {
  static let liveValue: QiitaClient = .live()
  
  static func live(apiClient: ApiClient = .liveValue) -> Self {
    .init(
      searchArticles: { query, page in
        try await apiClient.send(request: SearchArticlesRequest(query: query, page: page))
      }
    )
  }
}
