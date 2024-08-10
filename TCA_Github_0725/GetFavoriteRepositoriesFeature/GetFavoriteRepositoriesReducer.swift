import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct GetFavoriteRepositoriesReducer {
  public struct State: Equatable {
    var items = IdentifiedArrayOf<FavoriteRepositoryItemReducer.State>()
    
    public init() {}
  }
  
  public enum Action {
    case items(IdentifiedActionOf<FavoriteRepositoryItemReducer>)
    case getFavoriteReposResponse(Result<GetFavoriteReposResponse, Error>)
    case getFavoriteRepos
  }
  
  @Dependency(\.githubClient) var githubClient
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .getFavoriteReposResponse(.success(response)):
        state.items = .init(response: response)
        return .none
      case .getFavoriteReposResponse(.failure(let error)):
        print("getFavoriteReposResponseエラー: \(error)")
        return .none
      case .getFavoriteRepos:
        return .run { send in
          await send(.getFavoriteReposResponse(Result {
            try await githubClient.getFavoriteRepos()
          }))
        }
      case .items:
        return .none
      }
    }
    .forEach(\.items, action: \.items) {
      FavoriteRepositoryItemReducer()
    }
  }
}
