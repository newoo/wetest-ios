//
//  ArtistNameCollectionViewCell.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/28.
//

import UIKit
import RxSwift
import RxCocoa

class ArtistNameCollectionViewCell: UICollectionViewCell {
  static let identifier = "ArtistNameCollectionViewCell"
  
  private let nameLabel = UILabel()
  
  let nameInput = PublishRelay<String>()
  
  private var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setConstraints()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setConstraints() {
    addSubviews()
    
    nameLabel.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(4)
    }
  }
  
  private func addSubviews() {
    contentView.addSubview(nameLabel)
  }
  
  private func bind() {
    nameInput.observeOn(MainScheduler.instance)
      .bind(to: nameLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
