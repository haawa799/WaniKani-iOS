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

protocol FlippableCell {
  func flip(#animations: () -> Void, delay: NSTimeInterval)
}

class AvaliableItemCell: UICollectionViewCell {
  
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

extension AvaliableItemCell: FlippableCell {
  func flip(#animations: () -> Void, delay: NSTimeInterval){
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), {
        UIView.transitionWithView(self, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: animations, completion: nil)
    })
  }
}

extension AvaliableItemCell: SingleReuseIdentifier {
  static var identifier: String {
    return "avaliableCell"
  }
}
