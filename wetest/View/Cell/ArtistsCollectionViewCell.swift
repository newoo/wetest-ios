//
//  ArtistsCollectionViewCell.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ArtistsCollectionViewCell: UICollectionViewCell {
  static let identifier = "ArtistsCollectionViewCell"
  
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.minimumInteritemSpacing = 8
    layout.sectionInset = .init(top: 4, left: 16, bottom: 4, right: -16)
    
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(ArtistNameCollectionViewCell.self, forCellWithReuseIdentifier: ArtistNameCollectionViewCell.identifier)
    
    return collectionView
  }()
  
  let artistsInput = PublishRelay<[String]>()
  let selectedArtistOutput = PublishSubject<String>()
  
  private var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(collectionView)
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    artistsInput.filter { !$0.isEmpty }
      .bind(to: collectionView.rx.items(
        cellIdentifier: ArtistNameCollectionViewCell.identifier,
        cellType: ArtistNameCollectionViewCell.self
      )) { _, item, cell in
        cell.nameInput.accept(item)
      }.disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(String.self)
      .bind(to: selectedArtistOutput)
      .disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
