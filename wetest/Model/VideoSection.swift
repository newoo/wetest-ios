//
//  VideoSection.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import RxDataSources

struct VideoSection {
  enum SectionType: String, Comparable, CaseIterable {
    case video, artist
    
    var headerTitle: String {
      switch self {
      case .video:
        return "VIDEOS"
        
      case .artist:
        return "ARTISTS"
      }
    }
    
    static func < (lhs: SectionType, rhs: SectionType) -> Bool {
      guard let leftIndex = allCases.firstIndex(of: lhs),
            let rightIndex = allCases.firstIndex(of: rhs) else {
        return false
      }
      
      return leftIndex < rightIndex
    }
  }
  
  let type: SectionType
  var items: [VideoItem]
}

extension VideoSection: SectionModelType {
  typealias Identity = SectionType
  typealias Item = VideoItem
  
  var identity: SectionType {
    type
  }
  
  init(original: VideoSection, items: [VideoItem]) {
    self = original
    self.items = items
  }
}
