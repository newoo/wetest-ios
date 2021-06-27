//
//  RoundedTextField.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/28.
//

import UIKit

class RoundedTextField: UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    borderStyle = .roundedRect
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
