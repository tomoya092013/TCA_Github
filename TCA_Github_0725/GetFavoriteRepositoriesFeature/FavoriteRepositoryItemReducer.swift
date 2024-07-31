import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct FavoriteRepositoryItemReducer: Reducer {
  // MARK: - State
  public struct State: Equatable, Identifiable {
    public var id: Int { repository.id }
    let repository: Repository
    
    static func make(from item: GetFavoriteReposResponseItem) -> Self {
      .init(repository: .init(from: item))
    }
  }
}

extension IdentifiedArrayOf
where Element == FavoriteRepositoryItemReducer.State, ID == Int {
  init(response: GetFavoriteReposResponse) {
    self = IdentifiedArrayOf(uniqueElements: response.map { .make(from: $0) })
  }
}
