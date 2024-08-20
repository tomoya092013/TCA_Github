import Foundation
import APIKit

protocol QiitaRequest: BaseRequest {
}

extension QiitaRequest {
  var baseURL: URL { URL(string: "https://qiita.com")! }
  var headerFields: [String: String] { baseHeaders }
  var decoder: JSONDecoder { JSONDecoder() }
  
  var baseHeaders: [String: String] {
    var params: [String: String] = [:]
    params["Accept"] = "application/json"
    params["Authorization"] = "Bearer \(Confidential.qiitaToken)"
    return params
  }
}
