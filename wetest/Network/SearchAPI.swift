//
//  SearchAPI.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import MoyaSugar

enum SearchAPI: SugarTargetType {
  case musicVideos(term: String, country: String)
  
  var baseURL: URL {
    URL(string: "https://itunes.apple.com/search")!
  }
  
  var route: Route {
    switch self {
    case .musicVideos:
      return .get("")
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .musicVideos(term, country):
      return [
        "entity": "musicVideo",
        "term": term,
        "country": country
      ]
    }
  }
  
  var headers: [String: String]? {
    return ["Accept": "application/json"]
  }
  
  var sampleData: Data {
    func stub(_ fileName: String) -> Data {
      guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        return Data()
      }
      
      return data
    }
    
    switch self {
    case .musicVideos:
      return stub("VideosResponse")
    }
  }
}


