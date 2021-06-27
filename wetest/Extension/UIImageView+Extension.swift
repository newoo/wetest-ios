//
//  UIImageView+Extension.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/27.
//

import UIKit
import SDWebImage

extension UIImageView {
  func load(with path: String) {
    guard !path.isEmpty, let url = URL(string: path) else {
      return
    }
    
    sd_setImage(with: url, placeholderImage: nil)
  }
}
