import Foundation
import ComposableArchitecture
import Dependencies

@Reducer
struct SearchArticlesReducer: Reducer, Sendable {
  
  struct State: Equatable {
    var items = IdentifiedArrayOf<ArticleItemReducer.State>()
    var searchText: String = ""
    var textFieldFeature: SearchTextFieldReducer.State = .init()
    var currentPage = 1
    var loadingState: LoadingState = .refreshing
    var hasMorePage = false
    
    init() {}
  }
  
  enum LoadingState: Equatable {
    case refreshing
    case loadingNext
    case none
  }
  
  private enum CancelId { case searchArticles }
  
  // MARK: - Action
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case items(IdentifiedActionOf<ArticleItemReducer>)
    case itemAppeared(id: String)
    case searchArticlesResponse(Result<SearchArticlesResponse, Error>)
    case textFieldFeature(SearchTextFieldReducer.Action)
    case searchArticles(query: String, page: Int)
  }
  
  // MARK: - Dependencies
  @Dependency(\.qiitaClient) var qiitaClient
  
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
          return .cancel(id: CancelId.searchArticles)
        }
        state.currentPage = 1
        state.loadingState = .refreshing
        state.searchText = text
        let query = "title:\(state.searchText) body:\(state.searchText)"
        let page = state.currentPage
        return .run { send in
          await send(.searchArticles(query: query, page: page))
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
      case let .searchArticlesResponse(.success(response)):
        print(response)
        switch state.loadingState {
        case .refreshing:
          state.items = .init(response: response)
        case .loadingNext:
          let newItems = IdentifiedArrayOf(response: response)
          state.items.append(contentsOf: newItems)
        case .none:
          break
        }
        //        state.hasMorePage = response.totalCount > state.items.count
        state.loadingState = .none
        return .none
      case .searchArticlesResponse(.failure):
        return .none
        
      case let .itemAppeared(id: _id):
        state.currentPage += 1
        state.loadingState = .loadingNext
        let searchText = state.searchText
        let page = state.currentPage
        let query = "title:\(searchText) body:\(searchText)"
        return .run { send in
          await send(.searchArticles(query: query, page: page))
        }
      case .items:
        return .none
      case let .searchArticles(query: query, page: page):
        return .run { send in
          await send(.searchArticlesResponse(Result {
            try await qiitaClient.searchArticles(query: query, page: page)
          }))
        }
      }
    }
    .forEach(\.items, action: \.items) {
      ArticleItemReducer()
    }
    Scope(state: \.textFieldFeature, action: \.textFieldFeature) {
      SearchTextFieldReducer()
    }
  }
}

