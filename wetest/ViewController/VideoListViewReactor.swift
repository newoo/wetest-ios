//
//  VideoListViewReactor.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/26.
//

import ReactorKit

final class VideoListViewReactor: Reactor {
  enum Action {
    case search
    case selectArtist(String)
    case inputKeyword(String)
    case inputCountry1(String)
    case inputCountry2(String)
  }
  
  enum Mutation {
    case setVideos([Video])
    case setKeyword(String)
    case setCountry1(String)
    case setCountry2(String)
  }
  
  struct State {
    var artistNames = [String]()
    var videos = [Video]()
    var videoSections = [VideoSection]()
    var keyword = ""
    var country1 = ""
    var country2 = ""
    var isResponseEmpty = false
  }
  
  let initialState = State()
  
  let service: VideoService
  
  init(service: VideoService = .init()) {
    self.service = service
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .search, .selectArtist:
      var keyword = currentState.keyword
      
      if case let .selectArtist(name) = action {
        keyword = name
      }
      
      if keyword.isEmpty {
        return .empty()
      }
      
      let country1 = currentState.country1
      let country2 = currentState.country2
      
      switch (country1.isEmpty, country2.isEmpty) {
      case (true, true):
        return .empty()
        
      case (false, false):
        let response1 = service.getList(keyword: keyword, country: country1)
        let response2 = service.getList(keyword: keyword, country: country2)
        
        return Observable.combineLatest(response1, response2) { Set($0 + $1) }
          .map { Array($0) }
          .map { Mutation.setVideos($0) }
        
      case (false, true):
        return setVideos(keyword: keyword, country: country1)
        
      case (true, false):
        return setVideos(keyword: keyword, country: country2)
      }
      
    case let .inputKeyword(keyword):
      return .just(.setKeyword(keyword))
      
    case let .inputCountry1(country1):
      return .just(.setCountry1(country1))
      
    case let .inputCountry2(country2):
      return .just(.setCountry2(country2))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
    case let .setVideos(videos):
      state.videos = videos
      state.isResponseEmpty = videos.isEmpty
      
      let artistNames = Array(Set(videos.map { $0.artistName }))
      state.artistNames = artistNames
      
      let items = videos.map { VideoItem.video($0) }
      state.videoSections = [
        VideoSection(type: .artist, items: [VideoItem.artists(artistNames)]),
        VideoSection(type: .video, items: items)
      ]
      
    case let .setKeyword(keyword):
      state.isResponseEmpty = false
      state.keyword = keyword
      
    case let .setCountry1(country):
      state.isResponseEmpty = false
      state.country1 = country
      
    case let .setCountry2(country):
      state.isResponseEmpty = false
      state.country2 = country
    }
    
    return state
  }
  
  private func setVideos(keyword: String, country: String) -> Observable<Mutation> {
    return service.getList(keyword: keyword, country: country)
      .map { Set($0) }
      .map { Array($0) }
      .map { Mutation.setVideos($0) }
  }
}
