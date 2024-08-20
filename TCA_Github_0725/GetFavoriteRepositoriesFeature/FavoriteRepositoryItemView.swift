import SwiftUI
import ComposableArchitecture

struct FavoriteRepositoryItemView: View {
  let store: StoreOf<FavoriteRepositoryItemReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          Text(viewStore.repository.name)
            .font(.system(size: 20, weight: .bold))
            .lineLimit(1)
          
          HStack{
            Text(viewStore.repository.login)
              .font(.system(size: 16))
              .padding(.trailing)
            Label {
              Text("\(viewStore.repository.stars)")
                .font(.system(size: 14))
            } icon: {
              Image(systemName: "star.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.yellow)
            }
          }
        }
      }
    }
  }
}
