//
//  VideoViewController.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/28.
//

import UIKit
import SnapKit
import ReactorKit

class VideoViewController: UIViewController, View {
  typealias Reactor = VideoViewReactor
  
  private let collectionViewCell = VideoCollectionViewCell(frame: .zero)
  
  var disposeBag = DisposeBag()
  
  init(reactor: VideoViewReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .lightGray
    view.addSubview(collectionViewCell)
    
    collectionViewCell.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func bind(reactor: VideoViewReactor) {
    reactor.state.map { $0.video }
      .bind(to: collectionViewCell.videoInput)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.video.trackName }
      .bind(to: self.rx.title)
      .disposed(by: disposeBag)
  }
}
