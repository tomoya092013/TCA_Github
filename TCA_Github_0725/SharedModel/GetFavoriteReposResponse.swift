import Foundation

typealias GetFavoriteReposResponse = [GetFavoriteReposResponseItem]

struct GetFavoriteReposResponseItem: Sendable, Decodable, Equatable {
  let id: Int
  let name: String
  let fullName: String
  let owner: Owner
  let description: String?
  let stargazersCount: Int
  
  init(
    id: Int,
    name: String,
    fullName: String,
    owner: Owner,
    description: String?,
    stargazersCount: Int
  ) {
    self.id = id
    self.name = name
    self.fullName = fullName
    self.owner = owner
    self.description = description
    self.stargazersCount = stargazersCount
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case fullName = "full_name"
    case owner
    case description
    case stargazersCount = "stargazers_count"
  }
}

struct Owner: Sendable, Decodable, Equatable {
  let login: String
  let avatarUrl: URL
  
  init(login: String, avatarUrl: URL) {
    self.login = login
    self.avatarUrl = avatarUrl
  }
  
  enum CodingKeys: String, CodingKey {
    case login
    case avatarUrl = "avatar_url"
  }
}
