//
//  VideoItem.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import RxDataSources

enum VideoItem: IdentifiableType, Equatable {
  typealias Identity = String
  
  case video(Video)
  case artists([String])
  
  var identity: String {
    switch self {
    case let .video(video):
      return String(video.trackId.hashValue)
      
    case .artists:
      return String("artist".hashValue)
    }
  }
  
  static func == (lhs: VideoItem, rhs: VideoItem) -> Bool {
    return lhs.identity == rhs.identity
  }
}
