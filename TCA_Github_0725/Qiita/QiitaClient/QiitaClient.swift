import Dependencies
import DependenciesMacros

@DependencyClient
struct QiitaClient: Sendable {
  var searchArticles: @Sendable (_ query: String, _ page: Int) async throws -> SearchArticlesResponse
}

extension DependencyValues {
  var qiitaClient: QiitaClient {
    get { self[QiitaClient.self] }
    set { self[QiitaClient.self] = newValue }
  }
}
