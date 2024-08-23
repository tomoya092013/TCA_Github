import APIKit

struct SearchArticlesRequest: QiitaRequest {
  typealias Response = SearchArticlesResponse
  let method = APIKit.HTTPMethod.get
  let path = "api/v2/items"
  let queryParameters: [String: Any]?
  
  init(
    query: String,
    page: Int
  ) {
    self.queryParameters = [
      "query": query,
      "page": page.description,
      "per_page":  Confidential.perPage
    ]
  }
}
