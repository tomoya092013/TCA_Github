import SwiftUI
import ComposableArchitecture

struct ArticleItemView: View {
  let store: StoreOf<ArticleItemReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          Text(viewStore.article.title)
            .font(.system(size: 20, weight: .bold))
            .lineLimit(1)
          
          HStack{
            Text(viewStore.article.userId)
              .font(.system(size: 16))
              .padding(.trailing)
            Label {
              Text("\(viewStore.article.likesCount)")
                .font(.system(size: 14))
            } icon: {
              Image(systemName: "star.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.yellow)
            }
          }
          Text(viewStore.article.updatedAt)
            .font(.system(size: 14))
        }
      }
    }
  }
}
