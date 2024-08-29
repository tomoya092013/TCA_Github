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
//    var stockArticleFeature: ArticleItemReducer.State
    
    init() {}
  }
  
  enum LoadingState: Equatable {
    case refreshing
    case loadingNext
    case none
  }
  
  private enum CancelId { case searchArticles }
  
  // MARK: - Action
  enum Action: Sendable {
    case items(IdentifiedActionOf<ArticleItemReducer>)
    case itemAppeared(id: String)
    case searchArticlesResponse(Result<SearchArticlesResponse, Error>)
    case textFieldFeature(SearchTextFieldReducer.Action)
    case searchArticles(query: String, page: Int)
    case stockArticleResponse(Result<StockArticleResponse, Error>)
    case stockArticleFeature(ArticleItemReducer.Action)
  }
  
  // MARK: - Dependencies
  @Dependency(\.qiitaClient) var qiitaClient
  
  init() {}
  
  // MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
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
        state.hasMorePage = false
        state.searchText = ""
        return .none
      case .textFieldFeature(_):
        return .none
      case let .searchArticlesResponse(.success(response)):
        state.hasMorePage = response.count < Confidential.perPage ? false : true
        switch state.loadingState {
        case .refreshing:
          state.items = .init(response: response)
        case .loadingNext:
          let newItems = IdentifiedArrayOf(response: response)
          state.items.append(contentsOf: newItems)
        case .none:
          break
        }
        return .none
      case .searchArticlesResponse(.failure):
        return .none
      case let .itemAppeared(id: id):
        guard let lastItem = state.items.last else { return .none}
        if state.hasMorePage, lastItem.id == id {
          state.currentPage += 1
          state.loadingState = .loadingNext
          let searchText = state.searchText
          let page = state.currentPage
          let query = "title:\(searchText) body:\(searchText)"
          return .run { send in
            await send(.searchArticles(query: query, page: page))
          }
        } else {
          return .none
        }
      case let .searchArticles(query: query, page: page):
        return .run { send in
          await send(.searchArticlesResponse(Result {
            try await qiitaClient.searchArticles(query: query, page: page)
          }))
        }
        
      case let .stockArticleFeature(.stock(id: id)):
        print("SearchArticlesReducer",id)
        return .none
      case .stockArticleFeature(_):
        return .none
      case .stockArticleResponse(.success(_)):
        return .none
      case .stockArticleResponse(.failure(_)):
        return .none
      case .items:
        return .none
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
