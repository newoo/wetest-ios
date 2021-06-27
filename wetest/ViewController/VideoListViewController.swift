//
//  VideoListViewController.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

class VideoListViewController: UIViewController, ReactorKit.View {
  typealias Reactor = VideoListViewReactor
  
  private let searchTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "검색어를 입력해주세요."
    textField.borderStyle = .roundedRect
    
    return textField
  }()
  
  private let searchButton: UIButton = {
    let button = UIButton()
    button.setTitle("검색", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .purple
    
    return button
  }()
  
  private lazy var searchStackView: UIStackView = {
    let subviews = [searchTextField, searchButton]
    let stackView = UIStackView(arrangedSubviews: subviews)
    stackView.axis = .horizontal
    stackView.spacing = 16
    view.addSubview(stackView)
    
    return stackView
  }()
  
  func makeRoundedTextField() -> UITextField {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    
    return textField
  }
  
  private let countryTextFields = [RoundedTextField(), RoundedTextField()]
  
  private lazy var countryStackView: UIStackView = {
    let subviews = countryTextFields.enumerated()
      .map { CountryStackView(with: "country\($0 + 1)", textField: $1) }
    let stackView = UIStackView(arrangedSubviews: subviews)
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.distribution = .fillEqually
    view.addSubview(stackView)
    
    return stackView
  }()
  
  private let videoCollectionView: UICollectionView = {
    let width = (UIScreen.main.bounds.width - 50) / 2
    let height = width + 64
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 8
    layout.minimumLineSpacing = 16
    layout.sectionInset = .init(top: 8, left: 16, bottom: 0, right: 16)
    layout.headerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 32)
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(VideoCollectionViewCell.self,
                            forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
    collectionView.register(ArtistsCollectionViewCell.self,
                            forCellWithReuseIdentifier: ArtistsCollectionViewCell.identifier)
    collectionView.register(TextCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TextCollectionReusableView.identifier)
    
    return collectionView
  }()
  
  private lazy var videoDataSource = RxCollectionViewSectionedReloadDataSource<VideoSection>(
    configureCell: { [weak self] (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
      switch item {
      case let .artists(names):
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistsCollectionViewCell.identifier, for: indexPath) as? ArtistsCollectionViewCell
        cell?.artistsInput.accept(names)
        
        if let self = self, let reactor = self.reactor {
          self.cellDisposeBag = DisposeBag()
          cell?.selectedArtistOutput
            .bind(to: self.searchTextField.rx.text)
            .disposed(by: self.cellDisposeBag)
          
          cell?.selectedArtistOutput
            .map { Reactor.Action.selectArtist($0) }
            .bind(to: reactor.action)
            .disposed(by: self.cellDisposeBag)
        }
        
        return cell ?? UICollectionViewCell()
        
      case let .video(video):
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as? VideoCollectionViewCell
        cell?.videoInput.accept(video)
        return cell ?? UICollectionViewCell()
      }
    }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TextCollectionReusableView.identifier, for: indexPath) as? TextCollectionReusableView
      let title = dataSource.sectionModels[indexPath.section].type.headerTitle
      header?.textInput.accept(title)
      return header ?? TextCollectionReusableView()
    })
  
  var disposeBag = DisposeBag()
  private var cellDisposeBag = DisposeBag()
  
  init(reactor: VideoListViewReactor = .init()) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setConstraints()
    setDelegates()
  }
  
  private func setConstraints() {
    addSubviews()
    
    searchButton.snp.makeConstraints {
      $0.width.equalTo(50)
    }
    
    searchStackView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.height.equalTo(40)
    }
    
    countryStackView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
      $0.top.equalTo(searchStackView.snp.bottom).offset(16)
      $0.height.equalTo(40)
    }
    
    videoCollectionView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(countryStackView.snp.bottom).offset(8)
      $0.bottom.equalToSuperview()
    }
  }
  
  private func addSubviews() {
    view.addSubview(videoCollectionView)
  }
  
  private func setDelegates() {
    videoCollectionView.delegate = self
    searchTextField.delegate = self
    countryTextFields.forEach {
      $0.delegate = self
    }
  }
  
  func bind(reactor: VideoListViewReactor) {
    reactor.state.map { $0.videoSections }
      .bind(to: videoCollectionView.rx.items(dataSource: videoDataSource))
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.isResponseEmpty }
      .bind(to: self.rx.emptyItems)
      .disposed(by: disposeBag)
    
    searchTextField.rx.text
      .orEmpty
      .map { Reactor.Action.inputKeyword($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    countryTextFields[0].rx.text
      .orEmpty
      .map { Reactor.Action.inputCountry1($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    countryTextFields[1].rx.text
      .orEmpty
      .map { Reactor.Action.inputCountry2($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    searchButton.rx.tap
      .map { Reactor.Action.search }
      .do(onNext: { [weak self] _ in
        self?.view.endEditing(true)
      }).bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  fileprivate func presentAlert() {
    let alert = UIAlertController(title: "오류", message: "아티스트 이름 또는 국가코드를 정확히 입력해주세요.", preferredStyle: UIAlertController.Style.alert)
    let confirmAction = UIAlertAction(title: "확인", style: .cancel)
    alert.addAction(confirmAction)
    present(alert, animated: true, completion: nil)
  }
}

extension VideoListViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}

extension VideoListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if case .artist = videoDataSource.sectionModels[indexPath.section].type {
      return CGSize(width: UIScreen.main.bounds.width, height: 56)
    }
    
    let width = (UIScreen.main.bounds.width - 50) / 2
    let height = width + 64
    
    return CGSize(width: width, height: height)
  }
}

extension VideoListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    
    let section = videoDataSource.sectionModels[indexPath.section]
    guard case let .video(video) = section.items[indexPath.item] else {
      return
    }
    
    let videoViewReactor = VideoViewReactor(video: video)
    let videoViewController = VideoViewController(reactor: videoViewReactor)
    navigationController?.pushViewController(videoViewController,
                                             animated: true)
  }
}

extension Reactive where Base: VideoListViewController {
  var emptyItems: Binder<Bool> {
    return Binder(self.base) { base, isEmpty in
      if isEmpty {
        base.presentAlert()
      }
    }
  }
}
