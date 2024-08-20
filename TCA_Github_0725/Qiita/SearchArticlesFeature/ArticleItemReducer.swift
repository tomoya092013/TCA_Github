import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
struct ArticleItemReducer: Reducer {
  struct State: Equatable, Identifiable {
    var id: String { article.id }
    let article: Article
    
    static func make(from item: SearchArticleResponseItem) -> Self {
      .init(article: .init(from: item))
    }
  }
}

extension IdentifiedArrayOf
where Element == ArticleItemReducer.State, ID == String {
  init(response: SearchArticlesResponse) {
    self = IdentifiedArrayOf(uniqueElements: response.map { .make(from: $0) })
  }
}
