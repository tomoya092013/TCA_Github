import APIKit

typealias StockArticleResponse = Void

struct StockArticleRequest: QiitaRequest {
  struct StockArticleResponse: Decodable {
  }
  typealias Response = StockArticleResponse
  
  let method = APIKit.HTTPMethod.put
  var path: String
  
  init(id: String) {
    self.path = "/api/v2/items/\(id)/stock"
  }
}
