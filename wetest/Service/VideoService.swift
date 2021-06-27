//
//  VideoService.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/28.
//

import RxSwift

final class VideoService {
  let apiClient: APIClient<SearchAPI>
  
  init(apiClient: APIClient<SearchAPI> = .init()) {
    self.apiClient = apiClient
  }
  
  func getList(keyword: String, country: String) -> Observable<[Video]> {
    apiClient.request(.musicVideos(term: keyword, country: country))
      .map(ResultResponse.self)
      .map { $0.results }
      .catchErrorJustReturn([])
      .asObservable()
  }
}
