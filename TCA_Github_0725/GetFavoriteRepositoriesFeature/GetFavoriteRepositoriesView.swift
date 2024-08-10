import SwiftUI
import ComposableArchitecture

struct GetFavoriteRepositoriesView: View {
  let store: StoreOf<GetFavoriteRepositoriesReducer>
  
  public init(store: StoreOf<GetFavoriteRepositoriesReducer>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        List {
          ForEachStore(store.scope(state: \.items, action: \.items)) { itemStore in
            FavoriteRepositoryItemView(store: itemStore)
          }
        }
        .navigationBarTitle(Text("お気に入りRepository"))
      }
      .onAppear {
        viewStore.send(.getFavoriteRepos)
      }
    }
  }
}
