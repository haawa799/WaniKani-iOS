//
//  NextReviewCell.swift
//
//
//  Created by Andriy K. on 8/27/15.
//
//

import UIKit

protocol NextReviewCellDelegate: class {
  func notificationsEnabled(enabled: Bool)
}

class NextReviewCell: UICollectionViewCell {
  
  weak var delegate: NextReviewCellDelegate?
  
  @IBOutlet weak var notifyMeLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var flatSwitch: AIFlatSwitch!
  
  func setupWith(title: String, notifications: Bool) {
    titleLabel?.text = title
    flatSwitch?.selected = notifications
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel?.text = nil
  }
  
  @IBAction func switchValueChange(sender: AIFlatSwitch) {
    delegate?.notificationsEnabled(sender.selected)
  }
}

extension NextReviewCell: FlippableCell {
  func flip(animations animations: () -> Void, delay: NSTimeInterval){
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

extension NextReviewCell: SingleReuseIdentifier {
  static var identifier: String {
    return "nextReviewCell"
  }
}