import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
struct RepositoryItemReducer: Reducer, Sendable {
  // MARK: - State
  struct State: Equatable, Identifiable, Sendable {
    var id: Int { repository.id }
    let repository: Repository
    @BindingState var liked = false
    
    static func make(from item: SearchReposResponse.Item) -> Self {
      .init(repository: .init(from: item))
    }
  }
  
  // MARK: - Action
  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
  }
  
  // MARK: - Dependencies
  
  // MARK: - Reducer
  var body: some ReducerOf<Self> {
    BindingReducer()
  }
}

extension IdentifiedArrayOf
where Element == RepositoryItemReducer.State, ID == Int {
  init(response: SearchReposResponse) {
    self = IdentifiedArrayOf(uniqueElements: response.items.map { .make(from: $0) })
  }
}
