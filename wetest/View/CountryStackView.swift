//
//  CountryStackView.swift
//  wetest
//
//  Created by Taeheon Woo on 2021/06/26.
//

import UIKit

class CountryStackView: UIStackView {
  private let countryLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    
    return label
  }()
  
  init(with text: String, textField: UITextField) {
    countryLabel.text = text
    super.init(arrangedSubviews: [countryLabel, textField])
    axis = .horizontal
    distribution = .fillEqually
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
