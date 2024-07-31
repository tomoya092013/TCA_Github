import SwiftUI

@main
struct GithubApp: App {
  @State var selection = 1
  var body: some Scene {
    WindowGroup {
      TabView(selection: $selection) {
        SearchRepositoriesView(store: .init(initialState: .init()) {
          SearchRepositoriesReducer()
        })
        .tabItem{
          Label("Github", systemImage: "magnifyingglass")
        }.tag(1)
        
        GetFavoriteRepositoriesView(store: .init(initialState: .init()) {
          GetFavoriteRepositoriesReducer()
        })
          .tabItem{
            Label("GF", systemImage: "heart")
          }.tag(2)
        
        Text("Qiita")
          .tabItem{
            Label("Qiita", systemImage: "magnifyingglass")
          }.tag(3)
        
        Text("QF")
          .tabItem{
            Label("QF", systemImage: "heart")
          }.tag(4)
      }
    }
  }
}
