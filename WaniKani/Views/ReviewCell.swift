//
//  ReviewCell.swift
//  
//
//  Created by Andriy K. on 8/23/15.
//
//

import UIKit

class ReviewCell: UICollectionViewCell {

  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  func setupWith(title: String, numberText: String) {
    titleLabel?.text = title
    numberLabel?.text = numberText
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel?.text = nil
    numberLabel?.text = nil
  }
}

extension ReviewCell: FlippableCell {
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

extension ReviewCell: SingleReuseIdentifier {
  static var identifier: String {
    return "reviewCell"
  }
}