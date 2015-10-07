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
//    setup()
  }
  
  private func setup() {
    delay(1.0, closure: { () -> () in
      self.show()
    })
  }
  
  private func show() {
    UIView.animateWithDuration(0.6, animations: { () -> Void in
      self.frame = CGRect(x: 0, y: self.frame.origin.y - self.bounds.height, width: self.bounds.width, height: self.bounds.height)
    })
  }
  
}
