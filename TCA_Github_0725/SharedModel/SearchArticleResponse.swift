import Foundation

typealias SearchArticlesResponse = [SearchArticleResponseItem]

struct SearchArticleResponseItem: Sendable, Decodable, Equatable {
  let id: String
  let user: User
  let title: String
  let likesCount: Int
  let updatedAt: String
  
  init(
    id: String,
    user: User,
    title: String,
    likesCount: Int,
    updatedAt: String
  ) {
    self.id = id
    self.user = user
    self.title = title
    self.likesCount = likesCount
    self.updatedAt = updatedAt
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case user
    case title
    case likesCount = "likes_count"
    case updatedAt = "updated_at"
  }
}

struct User: Sendable, Decodable, Equatable {
  let userId: String
  let profileImage: URL
  
  init(
    userId: String,
    profileImage: URL
  ) {
    self.userId = userId
    self.profileImage = profileImage
  }
  
  enum CodingKeys: String, CodingKey {
    case userId = "id"
    case profileImage = "profile_image_url"
  }
}

