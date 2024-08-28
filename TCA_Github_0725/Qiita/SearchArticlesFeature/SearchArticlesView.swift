import SwiftUI
import ComposableArchitecture

struct SearchArticlesView: View {
  let store: StoreOf<SearchArticlesReducer>

  struct ViewState: Equatable {
    let hasMorePage: Bool
    
    init(store: BindingViewStore<SearchArticlesReducer.State>) {
      self.hasMorePage = store.hasMorePage
    }
  }
  
  init(store: StoreOf<SearchArticlesReducer>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: ViewState.init(store:)) { viewStore in
      VStack {
       SearchTextFieldView(
        store: self.store.scope(state: \.textFieldFeature, action: SearchArticlesReducer.Action.textFieldFeature)
       )
        List {
          ForEachStore(store.scope(state: \.items, action: \.items)) { itemStore in
            ArticleItemView(store: itemStore)
              .onAppear {
                viewStore.send(.itemAppeared(id: itemStore.withState(\.id)))
              }
          }
          if viewStore.hasMorePage {
            ProgressView()
              .frame(maxWidth: .infinity)
          }
        }
      }
    }
  }
}
