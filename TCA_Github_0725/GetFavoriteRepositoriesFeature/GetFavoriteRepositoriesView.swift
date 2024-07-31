import SwiftUI
import ComposableArchitecture

struct GetFavoriteRepositoriesView: View {
  let store: StoreOf<GetFavoriteRepositoriesReducer>
  
  public init(store: StoreOf<GetFavoriteRepositoriesReducer>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      List {
        ForEachStore(store.scope(
          state: \.items,
          action: GetFavoriteRepositoriesReducer.Action.items
        )) { itemStore in
          FavoriteRepositoryItemView(store: itemStore)
        }
      }
      .onAppear {
        viewStore.send(.getFavoriteRepos)
      }
      .navigationTitle("Favorite Repositories")
    }
  }
}
