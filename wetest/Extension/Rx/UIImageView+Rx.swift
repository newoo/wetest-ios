//
//  UIImageView+Rx.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIImageView {
  var imageURL: Binder<String> {
    return Binder(self.base) { imageView, path in
      imageView.load(with: path)
    }
  }
}
