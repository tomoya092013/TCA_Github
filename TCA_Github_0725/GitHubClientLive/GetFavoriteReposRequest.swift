import APIKit

struct GetFavoriteReposRequest: GithubRequest {
  typealias Response = GetFavoriteReposResponse
  let method = APIKit.HTTPMethod.get
  let path = "/user/starred"
}
