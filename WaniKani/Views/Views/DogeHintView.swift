//
//  DogeHintView.swift
//  
//
//  Created by Andriy K. on 9/10/15.
//
//

import UIKit

class DogeHintView: UIView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  private func setup() {
    transform = CGAffineTransformMakeTranslation(0, bounds.height)
    UIView.animateWithDuration(0.6, animations: { () -> Void in
      self.transform = CGAffineTransformIdentity
    })
  }
  
}
