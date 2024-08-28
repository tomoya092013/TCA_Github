import Foundation

struct Article: Equatable, Sendable {
  let id: String
  let userId: String
  let profileImage: URL
  let title: String
  let likesCount: Int
  let updatedAt: String
}

extension Article {
  init (from item: SearchArticleResponseItem) {
    self.id = item.id
    self.userId = item.user.userId
    self.profileImage = item.user.profileImage
    self.title = item.title
    self.likesCount = item.likesCount
    self.updatedAt = item.updatedAt
  }
}
