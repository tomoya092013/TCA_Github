import Dependencies
import DependenciesMacros

@DependencyClient
public struct GithubClient: Sendable {
  public var searchRepos: @Sendable (_ query: String, _ page: Int) async throws -> SearchReposResponse
  public var searchFavoriteRepos: @Sendable () async throws -> SearchFavoriteReposResponse
}

extension GithubClient: TestDependencyKey {
  public static let testValue = Self()
  public static let previewValue = Self()
}

public extension DependencyValues {
  var githubClient: GithubClient {
    get { self[GithubClient.self] }
    set { self[GithubClient.self] = newValue }
  }
}
