import Dependencies
import DependenciesMacros

@DependencyClient
struct GithubClient: Sendable {
  var searchRepos: @Sendable (_ query: String, _ page: Int) async throws -> SearchReposResponse
  var getFavoriteRepos: @Sendable () async throws -> GetFavoriteReposResponse
}

extension GithubClient: TestDependencyKey {
  static let testValue = Self()
  static let previewValue = Self()
}

extension DependencyValues {
  var githubClient: GithubClient {
    get { self[GithubClient.self] }
    set { self[GithubClient.self] = newValue }
  }
}
