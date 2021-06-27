//
//  VideoCollectionViewCell.swift
//  
//
//  Created by Taeheon Woo on 2021/06/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class VideoCollectionViewCell: UICollectionViewCell {
  static let identifier = "VideoTableViewCell"
  
  private let imageView = UIImageView()
  
  private let artistNameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15)
    
    return label
  }()
  
  private let trackNameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15)
    
    return label
  }()
  
  let videoInput = PublishRelay<Video>()
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .lightGray
    setConstraints()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraints() {
    addSubviews()
    
    imageView.snp.makeConstraints {
      $0.leading.top.trailing.equalToSuperview()
      $0.height.equalTo(contentView.snp.width)
    }
    
    artistNameLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(8)
      $0.top.equalTo(imageView.snp.bottom).offset(8)
      $0.height.equalTo(20)
    }
    
    trackNameLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(8)
      $0.top.equalTo(artistNameLabel.snp.bottom).offset(8)
      $0.bottom.equalToSuperview().offset(-8)
      $0.height.equalTo(20)
    }
  }
  
  private func addSubviews() {
    contentView.addSubview(imageView)
    contentView.addSubview(artistNameLabel)
    contentView.addSubview(trackNameLabel)
  }
  
  private func bind() {
    videoInput.map { $0.artworkUrl100 }
      .map { $0.replacingOccurrences(of: "100x100", with: "300x300") }
      .observeOn(MainScheduler.instance)
      .bind(to: imageView.rx.imageURL)
      .disposed(by: disposeBag)
    
    videoInput.map { $0.artistName }
      .observeOn(MainScheduler.instance)
      .bind(to: artistNameLabel.rx.text)
      .disposed(by: disposeBag)
    
    videoInput.map { $0.trackName }
      .observeOn(MainScheduler.instance)
      .bind(to: trackNameLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
