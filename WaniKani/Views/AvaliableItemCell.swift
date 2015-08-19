//
//  AvaliableItemCell.swift
//  
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

protocol SingleReuseIdentifier {
  static var identifier: String {get}
}

class AvaliableItemCell: UICollectionViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var disclosureButton: UIButton!
  
  func setupWith(text: String, enabled: Bool) {
    titleLabel?.text = text
    disclosureButton?.hidden = !enabled
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel?.text = nil
    disclosureButton?.hidden = true
  }
  
}

extension AvaliableItemCell: SingleReuseIdentifier {
  static var identifier: String {
    return "avaliableCell"
  }
}
