//
//  Video.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import Foundation

struct Video: Decodable, Hashable {
  let trackId: Int
  let artistId: Int
  let artistName: String
  let trackName: String
  let artworkUrl60: String
  let artworkUrl100: String
  
  enum CodingKeys: String, CodingKey {
    case trackId, artistId, artistName, trackName,
         artworkUrl60, artworkUrl100
  }
}
