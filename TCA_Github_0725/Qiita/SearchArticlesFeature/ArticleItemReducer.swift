import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
struct ArticleItemReducer: Reducer, Sendable {
  struct State: Equatable, Identifiable, Sendable {
    var id: String { article.id }
    let article: Article
    var liked = false
    
    static func make(from item: SearchArticleResponseItem) -> Self {
      .init(article: .init(from: item))
    }
  }
  
  enum Action: Equatable, Sendable {
    case didTapStockButton
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .didTapStockButton:
        state.liked.toggle()
        return .none
      }
    }
  }
}

extension IdentifiedArrayOf
where Element == ArticleItemReducer.State, ID == String {
  init(response: SearchArticlesResponse) {
    self = IdentifiedArrayOf(uniqueElements: response.map { .make(from: $0) })
  }
}
