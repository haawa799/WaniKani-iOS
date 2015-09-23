//
//  AvaliableItemCell.swift
//
//
//  Created by Andriy K. on 8/19/15.
//
//

import UIKit

class AvaliableItemCell: UICollectionViewCell, FlippableView, SingleReuseIdentifier {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var disclosureButton: UIButton!
  
  var enabled: Bool = false {
    didSet {
      disclosureButton?.hidden = !enabled
    }
  }
  
  func setupWith(text: String, enabled: Bool) {
    titleLabel?.text = text
    self.enabled = enabled
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel?.text = nil
    disclosureButton?.hidden = true
  }
}
