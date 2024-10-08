import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
struct SearchRepositoriesReducer: Reducer, Sendable {
  // MARK: - State
  struct State: Equatable {
    var items = IdentifiedArrayOf<RepositoryItemReducer.State>()
    @BindingState var showFavoritesOnly = false
    var currentPage = 1
    var loadingState: LoadingState = .refreshing
    var hasMorePage = false
    var path = StackState<RepositoryDetailReducer.State>()
    var filteredItems: IdentifiedArrayOf<RepositoryItemReducer.State> {
      items.filter {
        !showFavoritesOnly || $0.liked
      }
    }
    var searchText: String = ""
    var textFieldFeature: SearchTextFieldReducer.State = .init()
    var favoriteItems:SearchReposResponse?
    
    init() {}
  }
  
  enum LoadingState: Equatable {
    case refreshing
    case loadingNext
    case none
  }
  
  private enum CancelId { case searchRepos }
  
  // MARK: - Action
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case items(IdentifiedActionOf<RepositoryItemReducer>)
    case itemAppeared(id: Int)
    case searchReposResponse(Result<SearchReposResponse, Error>)
    case path(StackAction<RepositoryDetailReducer.State, RepositoryDetailReducer.Action>)
    case textFieldFeature(SearchTextFieldReducer.Action)
    case searchRepos(query: String, page: Int)
  }
  
  // MARK: - Dependencies
  @Dependency(\.githubClient) var githubClient
  
  init() {}
  
  // MARK: - Reducer
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(_):
        return .none
        
      case let .textFieldFeature(.search(text: text)):
        guard !text.isEmpty else {
          state.hasMorePage = false
          state.items.removeAll()
          return .cancel(id: CancelId.searchRepos)
        }
        state.searchText = text
        state.currentPage = 1
        state.loadingState = .refreshing
        let query = state.searchText
        let page = state.currentPage
        return .run { send in
          await send(.searchRepos(query: query, page: page))
        }
      case .textFieldFeature(.didTapCancelButton):
        state.searchText = ""
        state.hasMorePage = false
        state.items.removeAll()
        return .none
      case .textFieldFeature(.didTapClearTextButton):
        state.searchText = ""
        return .none
      case .textFieldFeature(_):
        return .none
      case let .searchReposResponse(.success(response)):
        switch state.loadingState {
        case .refreshing:
          state.items = .init(response: response)
        case .loadingNext:
          let newItems = IdentifiedArrayOf(response: response)
          state.items.append(contentsOf: newItems)
        case .none:
          break
        }
        state.hasMorePage = response.totalCount > state.items.count
        state.loadingState = .none
        return .none
      case .searchReposResponse(.failure):
        return .none
        
      case let .itemAppeared(id: id):
        if state.hasMorePage, state.items.index(id: id) == state.items.count - 1 {
          state.currentPage += 1
          state.loadingState = .loadingNext
          let query = state.searchText
          let page = state.currentPage
          return .run { send in
            await send(.searchRepos(query: query, page: page))
          }
        } else {
          return .none
        }
      case .items:
        return .none
      case let .path(.element(id: id, action: .binding(\.$liked))):
        guard let repositoryDetail = state.path[id: id] else { return .none }
        state.items[id: repositoryDetail.id]?.liked = repositoryDetail.liked
        return .none
      case .path:
        return .none
      case .searchRepos(query: let query, page: let page):
        return .run { send in
          await send(.searchReposResponse(Result {
            try await githubClient.searchRepos(query: query, page: page)
          }))
        }
      }
    }
    .forEach(\.items, action: \.items) {
      RepositoryItemReducer()
    }
    .forEach(\.path, action: \.path) {
      RepositoryDetailReducer()
    }
    Scope(state: \.textFieldFeature, action: /Action.textFieldFeature) {
      SearchTextFieldReducer()
    }
  }
}

