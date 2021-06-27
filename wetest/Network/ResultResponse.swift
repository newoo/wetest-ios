//
//  ResultResponse.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import Foundation

struct ResultResponse: Decodable {
  let resultCount: Int
  let results: [Video]
  
  enum CodingKeys: String, CodingKey {
    case resultCount, results
  }
}
