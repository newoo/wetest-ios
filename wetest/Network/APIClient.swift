//
//  APIClient.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import MoyaSugar
import RxSwift

final class APIClient<Target: SugarTargetType>: MoyaSugarProvider<Target> {
  init(stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
       plugins: [PluginType] = []) {
    let session = MoyaProvider<Target>.defaultAlamofireSession()
    session.sessionConfiguration.timeoutIntervalForRequest = 10

    super.init(stubClosure: stubClosure, session: session, plugins: plugins)
  }

  func request(_ target: Target) -> Single<Response> {
    return self.rx.request(target).filterSuccessfulStatusCodes()
  }
}
