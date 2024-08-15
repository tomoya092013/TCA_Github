import Foundation

struct Repository: Equatable, Sendable {
  let id: Int
  let name: String
  let avatarUrl: URL
  let description: String?
  let stars: Int
  let login: String
}

extension Repository {
  init (from item: SearchReposResponse.Item) {
    self.id = item.id
    self.name = item.fullName
    self.avatarUrl = item.owner.avatarUrl
    self.description = item.description
    self.stars = item.stargazersCount
    self.login = item.owner.login
  }
}

extension Repository {
  init (from item: GetFavoriteReposResponseItem) {
    self.id = item.id
    self.name = item.fullName
    self.avatarUrl = item.owner.avatarUrl
    self.description = item.description
    self.stars = item.stargazersCount
    self.login = item.owner.login
  }
}
