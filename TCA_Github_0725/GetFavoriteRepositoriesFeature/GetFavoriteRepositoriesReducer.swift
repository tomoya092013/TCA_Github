import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
struct GetFavoriteRepositoriesReducer {
  struct State: Equatable {
    var items = IdentifiedArrayOf<FavoriteRepositoryItemReducer.State>()
    
    init() {}
  }
  
  enum Action {
    case items(IdentifiedActionOf<FavoriteRepositoryItemReducer>)
    case getFavoriteReposResponse(Result<GetFavoriteReposResponse, Error>)
    case getFavoriteRepos
  }
  
  @Dependency(\.githubClient) var githubClient
  
  init() {}
  
  var body: some ReducerOf<Self> {
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
