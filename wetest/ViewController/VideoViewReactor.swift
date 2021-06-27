//
//  VideoViewReactor.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/28.
//

import ReactorKit

final class VideoViewReactor: Reactor {
  typealias Action = Never
  
  struct State {
    var video: Video
  }
  
  let initialState: State
  
  init(video: Video) {
    self.initialState = State(video: video)
  }
}

