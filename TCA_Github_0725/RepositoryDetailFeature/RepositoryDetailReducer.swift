import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
struct RepositoryDetailReducer: Reducer, Sendable {
  // MARK: - State
  struct State: Equatable, Sendable {
    var id: Int { repository.id }
    let repository: Repository
    @BindingState var liked = false
    
    init(
      repository: Repository,
      liked: Bool
    ) {
      self.repository = repository
      self.liked = liked
    }
  }
  
  init() {}
  
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
