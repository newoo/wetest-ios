//
//  TextCollectionReusableView.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TextCollectionReusableView: UICollectionReusableView {
  static let identifier = "TextCollectionReusableView"
  
  let textInput = PublishRelay<String>()
  
  private var disposeBag = DisposeBag()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 16)
    
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    backgroundColor = .lightGray
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(8)
      $0.centerY.equalToSuperview()
    }
    
    textInput.bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
